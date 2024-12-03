;;; Course: CISC813 - Automated Planning
;;; Assignment 5 - Temporal Planning
;;; Author: Amir Shetaia
;;; Email: a.shetaia@queensu.ca

;;; Domain: Electronics Manufacturing
;;; This domain models the processes within an electronics manufacturing facility.
;;; It includes:
;;; - Mobile robots for transportation.
;;; - Multiple workstations for assembly, testing, painting, and packaging.
;;; - Machines with varying functions and constraints.
;;; - Durative actions that simulate the time taken by activities.
;;; - Management of resource levels, such as battery life for robots.

(define (domain electronics_manufacturing)

    ;; Declare requirements for the domain:
    (:requirements :typing :durative-actions :fluents)

    ;; Define types and subtypes used in the domain.
    ;; Machines are further classified into specific roles.
    (:types 
        location                ; Represents places like workstations and storage areas.
        robot                   ; Mobile robots used for moving components.
        component               ; Raw materials or partially assembled components.
        machine                 ; Base type for machines used in the facility.
        assembler tester painter packager - machine ; Specific machine types.
    )

    ;; Define predicates, which describe the state of the system.
    (:predicates
        ;; Robot location tracking.
        (robot-at ?r - robot ?l - location)  
        
        ;; Component location tracking.
        (component-at ?c - component ?l - location)  
        
        ;; Machine location tracking.
        (machine-at ?m - machine ?l - location)  
        
        ;; Indicates if a machine is available for use.
        (machine-available ?m - machine) 
        
        ;; Describes connected locations for robot movement.
        (connected ?l1 ?l2 - location)  

        ;; Track the status of components through the production stages.
        (assembled ?c - component) 
        (tested ?c - component)
        (painted ?c - component)
        (packaged ?c - component)

        ;; Predicates to categorize locations by function.
        (is-storage ?l - location)
        (is-assembly-station ?l - location)
        (is-testing-station ?l - location)
        (is-painting-station ?l - location)
        (is-packaging-station ?l - location)
        (is-maintenance-station ?l - location)
    )

    ;; Define numeric functions to track dynamic quantities.
    (:functions
        ;; Track the battery level of each robot.
        (battery-level ?r - robot) 

        ;; Record the processing time required by each machine.
        (processing-time ?m - machine)  
    )

    ;; Define durative actions, which simulate processes that take time.

    ;; Action: Move a robot between two connected locations.
    (:durative-action move-robot
        :parameters (?r - robot ?from ?to - location)  ; Robot and locations involved.
        :duration (= ?duration 3)  ; Takes 3 time units to move.
        :condition (and
            (at start (robot-at ?r ?from))           ; Robot starts at the `from` location.
            (at start (connected ?from ?to))         ; The locations must be connected.
            (at start (>= (battery-level ?r) 5))     ; Robot must have enough battery.
        )
        :effect (and
            (at start (not (robot-at ?r ?from)))     ; Robot leaves the `from` location.
            (at end (robot-at ?r ?to))               ; Robot arrives at the `to` location.
            (at end (decrease (battery-level ?r) 5)) ; Battery decreases by 5 units.
        )
    )

    ;; Action: Transport a component using a robot.
    (:durative-action transport-component
        :parameters (?r - robot ?c - component ?from ?to - location)
        :duration (= ?duration 4)  ; Transport takes 4 time units.
        :condition (and
            (at start (robot-at ?r ?from))
            (at start (component-at ?c ?from))
            (at start (connected ?from ?to))
            (at start (>= (battery-level ?r) 8))  ; Requires 8 battery units.
        )
        :effect (and
            (at start (not (component-at ?c ?from)))
            (at start (not (robot-at ?r ?from)))
            (at end (component-at ?c ?to))
            (at end (robot-at ?r ?to))
            (at end (decrease (battery-level ?r) 8))
        )
    )

    ;; Action: Assemble a component using an assembler machine.
    (:durative-action assemble-component
        :parameters (?m - assembler ?c - component ?l - location)
        :duration (= ?duration (processing-time ?m))  ; Depends on the machine's speed.
        :condition (and
            (at start (machine-at ?m ?l))
            (at start (component-at ?c ?l))
            (at start (machine-available ?m))
            (at start (is-assembly-station ?l))
        )
        :effect (and
            (at start (not (machine-available ?m)))  ; Machine is occupied.
            (at end (assembled ?c))                 ; Component is assembled.
            (at end (machine-available ?m))         ; Machine becomes available.
        )
    )

    ;; Action: Test a component using a tester machine.
    (:durative-action test-component
        :parameters (?m - tester ?c - component ?l - location)
        :duration (= ?duration (processing-time ?m))
        :condition (and
            (at start (machine-at ?m ?l))
            (at start (component-at ?c ?l))
            (at start (assembled ?c))              ; Requires assembly first.
            (at start (machine-available ?m))
            (at start (is-testing-station ?l))
        )
        :effect (and
            (at start (not (machine-available ?m)))
            (at end (tested ?c))
            (at end (machine-available ?m))
        )
    )

    ;; Action: Paint a component using a painter machine.
    (:durative-action paint-component
        :parameters (?m - painter ?c - component ?l - location)
        :duration (= ?duration (processing-time ?m))
        :condition (and
            (at start (machine-at ?m ?l))
            (at start (component-at ?c ?l))
            (at start (tested ?c))                 ; Requires testing first.
            (at start (machine-available ?m))
            (at start (is-painting-station ?l))
        )
        :effect (and
            (at start (not (machine-available ?m)))
            (at end (painted ?c))
            (at end (machine-available ?m))
        )
    )

    ;; Action: Package a component using a packaging machine.
    (:durative-action package-component
        :parameters (?m - packager ?c - component ?l - location)
        :duration (= ?duration (processing-time ?m))
        :condition (and
            (at start (machine-at ?m ?l))
            (at start (component-at ?c ?l))
            (at start (painted ?c))                ; Requires painting first.
            (at start (machine-available ?m))
            (at start (is-packaging-station ?l))
        )
        :effect (and
            (at start (not (machine-available ?m)))
            (at end (packaged ?c))
            (at end (machine-available ?m))
        )
    )

    ;; Action: Recharge a robot at a maintenance station.
    (:durative-action recharge-robot
        :parameters (?r - robot ?l - location)
        :duration (= ?duration 10)  ; Recharging takes 10 time units.
        :condition (and
            (at start (robot-at ?r ?l))
            (at start (is-maintenance-station ?l))
        )
        :effect (and
            (at end (assign (battery-level ?r) 100))  ; Battery is fully recharged.
        )
    )
)
