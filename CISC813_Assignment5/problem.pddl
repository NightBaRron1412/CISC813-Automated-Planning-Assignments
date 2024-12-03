;;; Course: CISC813 - Automated Planning
;;; Assignment 5 - Temporal Planning
;;; Author: Amir Shetaia
;;; Email: a.shetaia@queensu.ca

;;; Problem: Electronics Manufacturing Problem Instance
;;; This problem models the manufacturing process involving multiple components,
;;; mobile robots, and workstations. It ensures that all components are processed 
;;; through the required stages and manages robot battery levels and recharging 
;;; to optimize operations.

(define (problem electronics_manufacturing_p1)
    ;; This line links the problem instance to the corresponding domain definition.
    (:domain electronics_manufacturing) 

    ;; Declare the objects used in the problem.
    (:objects
        ;; Define locations where activities take place.
        storage assembly-station testing-station painting-station 
        packaging-station maintenance-station - location

        ;; Define two mobile robots available for use.
        robot1 robot2 - robot

        ;; List of components to be processed through the stages.
        component1 component2 component3 component4 component5 - component

        ;; Machines used for various processes, categorized by type.
        assembler - assembler
        tester - tester
        painter - painter
        packager - packager
    )

    ;; Define the initial state of the problem, including the status of machines,
    ;; robots, components, and other relevant details.
    (:init
        ;; Specify the types of stations for each location.
        (is-storage storage)
        (is-assembly-station assembly-station)
        (is-testing-station testing-station)
        (is-painting-station painting-station)
        (is-packaging-station packaging-station)
        (is-maintenance-station maintenance-station)

        ;; Define connections between locations (bidirectional).
        ;; This allows robots to move between these locations.
        (connected storage assembly-station)
        (connected assembly-station storage)
        (connected assembly-station testing-station)
        (connected testing-station assembly-station)
        (connected testing-station painting-station)
        (connected painting-station testing-station)
        (connected painting-station packaging-station)
        (connected packaging-station painting-station)
        (connected packaging-station maintenance-station)
        (connected maintenance-station packaging-station)
        (connected maintenance-station storage)
        (connected storage maintenance-station)

        ;; Define the initial locations and battery levels of the robots.
        (robot-at robot1 storage)
        (robot-at robot2 storage)
        (= (battery-level robot1) 55)  ; Robot1 starts with 55 battery units.
        (= (battery-level robot2) 55)  ; Robot2 starts with 55 battery units.

        ;; Set the initial locations of all components in the storage area.
        (component-at component1 storage)
        (component-at component2 storage)
        (component-at component3 storage)
        (component-at component4 storage)
        (component-at component5 storage)

        ;; Define the locations and availability of the machines.
        ;; Each machine is initially available at its designated station.
        (machine-at assembler assembly-station)
        (machine-at tester testing-station)
        (machine-at painter painting-station)
        (machine-at packager packaging-station)
        (machine-available assembler)
        (machine-available tester)
        (machine-available painter)
        (machine-available packager)

        ;; Specify the processing times for each machine.
        ;; These values determine how long each process will take.
        (= (processing-time assembler) 8)  ; Assembling takes 8 time units.
        (= (processing-time tester) 5)     ; Testing takes 5 time units.
        (= (processing-time painter) 6)    ; Painting takes 6 time units.
        (= (processing-time packager) 4)   ; Packaging takes 4 time units.
    )

    ;; Define the goal state to be achieved at the end of the plan.
    (:goal
        (and
            ;; All components must be fully processed through all stages (packaged).
            (packaged component1)
            (packaged component2)
            (packaged component3)
            (packaged component4)
            (packaged component5)

            ;; Robots should return to the storage location after completing tasks.
            (robot-at robot1 storage)
            (robot-at robot2 storage)
        )
    )

    ;; Define the optimization metric.
    ;; In this case, the objective is to minimize the total makespan (time).
    (:metric minimize (total-time))
)
