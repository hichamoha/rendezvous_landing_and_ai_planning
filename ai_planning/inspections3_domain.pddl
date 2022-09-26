
;; In this project, we will formulate a small-scale practical robotic inspection problem in PDDL.
;; our model will have objects of different types, and we will assign each action a cost, so
;; that we can express the objective function.

;; Predicates:
;;      spot-reachable from-spot-pos to-spot-pos
;;	spot-inspectable ?spot-pos ?inspect-pos
;;	uav-inspectable ?spot-pos ?inspect-pos
;;      spot-at spot-pos
;;	uav-at ?uav - uav ?inspect-pos
;;      inspected inspect-pos
;;	attached ?uav - uav ?spot
;; Actions:
;;      move-spot(from-spot-pos, to-spot-pos) spot-pos - yellow
;;      inspect-spot(from-spot-pos, inspect-pos) inspect-pos – blue
;;      inspect-uav(inspect-pos) – can be extended to include fly-to, take-off, land, and COST

;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (domain inspections3)
    
    (:requirements :strips :typing :fluents :action-costs)

    (:types 
	;; declare two different object types: robots and the their locations
	;; as well as the locations of the inspection points
	spot uav position - object
    )     

    (:predicates
	;; Reachability of locations for Spot robot
	(spot-reachable ?from-spot-pos ?to-spot-pos - position)

	;; Visibility: when objective/inspection point is visible for Spot
	(spot-inspectable ?spot-pos ?inspect-pos - position)
	
	;; Sometimes some inspection points are partially or completely non-inspectable with Spot.
	;; That can be caused for example by high/vertical and/or occult construction which is 
	;; difficult-to-access for Spot robot. Thus, UAV should intervene to inspect instead of Spot.
	;; uav-inspectable(from-pos, inspect-pos) with the "intended semantics" that it can take-off, 
	;; fly, inspect, fly-back and land as one uav-do-inspection action. 
	(uav-inspectable ?spot-pos ?inspect-pos - position)

    	;(spot-at ?spot-pos - position)
	(spot-at ?spot - spot ?spot-pos - position)
    	
	;; predicate to express the goal:
    	(inspected ?inspect-pos - position)

    	(uav-at ?uav - uav ?inspect-pos - position)	
		
    	;; state when uav is at the top of Spot
    	(attached ?uav - uav ?spot - spot) 
    
    )

    (:functions
        (total-cost) - number

	; Operation time (optimization metric) [s], the total time consumed for moving
	;(total-time) - number
	;(time ?from ?to - position)  ; the duration of one specific transit/move
    )
        
    ; Action schema (parameterised action definition) of "move-spot" action
    ; NOTE: The values that parameters can assume correspond to objects declared 
    ; in the PDDL problem definition.
    (:action move-spot
        :parameters (?spot - spot
                     ?uav - uav
                     ?from-spot-pos - position
                     ?to-spot-pos - position)

        :precondition (and 
            (attached ?uav ?spot)
			(spot-at ?spot ?from-spot-pos)
			(spot-reachable ?from-spot-pos ?to-spot-pos))

        :effect (and (spot-at ?spot ?to-spot-pos)
                     (uav-at ?uav ?to-spot-pos)
                     (not (spot-at ?spot ?from-spot-pos))
                     (increase (total-cost) 1))      
		     ;; Increase the total time by the transit/move duration 	
		     ;(increase (total-time) (time ?from ?to))	

    )
    (:action inspect-spot
        :parameters (?spot - spot 
		     ?spot-pos - position
                     ?inspect-pos - position)

        :precondition (and
			(spot-inspectable ?spot-pos ?inspect-pos) 
			(spot-at ?spot ?spot-pos) 
                        (not (inspected ?inspect-pos)))
        
        ; This effect makes predicate (inspected ?inspect-pos) true
        ; so that the robot won't return to this point later in the plan.
        :effect (and (inspected ?inspect-pos)
                     (increase (total-cost) 2))

    )
    (:action inspect-uav
        :parameters (?dji - uav 
		     ?dji-pos - position
                     ?inspect-pos - position)

        :precondition (and (uav-inspectable ?dji-pos ?inspect-pos) 
			   (uav-at ?dji ?dji-pos)            
                           (not (inspected ?inspect-pos)))
                           ;(not (spot-reachable ?spot-pos ?inspect-pos))
                           ;(not (spot-inspectable ?spot-pos ?inspect-pos)))
			

        :effect (and (inspected ?inspect-pos)
                     (increase (total-cost) 1))
    )
)
