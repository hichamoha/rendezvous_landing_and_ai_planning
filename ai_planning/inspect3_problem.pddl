
;; The following is a small instance of an "inspection problem" with two robots and five inspection points,
;; where Spot start at point ip0 and come back to it at the end of the mission:


( define (problem inspect03)
    (:domain inspections3)

    (:objects
        spot1 - spot
        dji1 - uav
        sp0 sp1 sp2 sp3 sp4 sp5 sp6 - position
        ip0 ip1 ip2 ip3 ip4 ip5 ip6 - position
        
    )
    
    ; The :init section lists the facts that are "true" in the initial state
    (:init
    	;; An initial state: The state of the world that we start in

	; The starting position of Spot1 and dji1
    	(spot-at spot1 sp0) 
    	(uav-at dji1 sp0) 
    	(attached dji1 spot1)

	;; initialise total cost to zero:
    	(= (total-cost) 0)
        ;; Initialize total transition/moving time
        ;(= (total-time) 0)
        
    	;; Defining the topology of the problem: The way in which constituent parts 
	;; are interrelated or arranged, i.e., connections between inspection points reachable for Spot.
	;; This means that we have to define all nodes/inspection points and their connections.
	;; In other words, what nodes are adjacent with each other. In this way, we can generate
	;; the information of the route between tasks/goals.

	;; The task-planner is responsible of ordering the tasks/goals to minimize the distance 
	;; travelled for the final plan.
		
        (spot-reachable sp0 sp3)
        ;(= (time sp0 sp3) 2)      ;; Initialize the duration 
				   ;; for transiting/moving between insp. points
	(spot-reachable sp0 sp5)
        ;(= (time sp0 sp5) 1)
	
	(spot-reachable sp1 sp2)
	;(= (time sp1 sp2) 2)
	(spot-reachable sp1 sp3)
	;(= (time sp1 sp3) 1)
	(spot-reachable sp1 sp4)
	;(= (time sp1 sp4) 2)
	
	(spot-reachable sp2 sp1)
	;(= (time sp2 sp1) 1)
	(spot-reachable sp2 sp5)
	;(= (time sp2 sp5) 2)
	
	(spot-reachable sp3 sp0)
	;(= (time sp3 sp0) 1)
	(spot-reachable sp3 sp1)
	;(= (time sp3 sp1) 2)
	(spot-reachable sp3 sp4)
	;(= (time sp3 sp4) 1)
	
	(spot-reachable sp4 sp1)
	;(= (time sp4 sp1) 2)
	(spot-reachable sp4 sp3)
	;(= (time sp4 sp3) 1)
	(spot-reachable sp4 sp5)
	;(= (time sp4 sp5) 2)
	
	(spot-reachable sp5 sp0)
	;(= (time sp5 sp0) 1)
	(spot-reachable sp5 sp2)
	;(= (time sp5 sp2) 2)
	(spot-reachable sp5 sp4)
	;(= (time sp5 sp4) 1)

	;(not(spot-inspectable sp1 ip1)) ; we don't need negated literal, 
	                                 ; it is false by default, 
	                                 ; have only a list of facts that are TRUE
	(spot-inspectable sp2 ip2)
	(spot-inspectable sp3 ip3)
	(spot-inspectable sp4 ip4)
	(spot-inspectable sp5 ip5)
	
	; Let's consider the case where ip6 is not reachable by Spot
	(uav-inspectable sp5 ip6)
				
    )

    ; The :goal section lists the "conjunction of facts" that must be
    ; "true" for the goal to be achieved.
    (:goal
        (and  (inspected ip2) (inspected ip3) (inspected ip4)
              (inspected ip5) (inspected ip6))

    )
    
    (:metric 
        minimize (total-cost)
    )

    ;; Minimize the transit/move time	 
    ;(:metric minimize (total-time))  ;; Minimize the transit/move time	
)
