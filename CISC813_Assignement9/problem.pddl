;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Problem: Space Colony Expansion
; Description: Tasks workers to collect resources and build essential structures 
;              for a functional space colony. Workers must navigate a connected 
;              map to gather resources and construct buildings at designated locations.
; Author: Amir Shetaia
; Class: CISC813 - Automated Planning
; Email: a.shetaia@queensu.ca
; Assignment: 9 (Assignment 1 Modelling)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (problem colony-construction)
  (:domain space-colony-builder)

  ;;; Objects
  ;;   - Locations: Represent areas in the space colony map.
  ;;   - Workers: Represent the labor force for construction and resource collection.
  ;;   - Resources: Represent the materials required for building.
  ;;   - Buildings: Represent structures that need to be constructed.
  (:objects
    ; Locations in the colony map
    loc1 loc2 loc3 loc4 loc5 loc6 loc7 - location

    ; Workers available for tasks
    worker1 worker2 worker3 - worker

    ; Resources to be collected
    metal energy crystal water oxygen - resource

    ; Buildings to be constructed
    solar-panel habitat laboratory oxygen-generator farm - building
  )

  ;;; Initial State
  ;;   - Map connections define navigable paths between locations.
  ;;   - Free locations indicate where buildings can be constructed.
  ;;   - Resources are available at specific locations.
  ;;   - Workers are initially positioned at different locations and are available for tasks.
  ;;   - Each building has defined resource requirements for completion.
  (:init
    ;; Map connections
    ;; - Locations are connected in a circular layout with additional cross-links.
    (connected loc1 loc2)
    (connected loc2 loc3)
    (connected loc3 loc4)
    (connected loc4 loc5)
    (connected loc5 loc1)
    (connected loc2 loc4)
    (connected loc1 loc3)
    (connected loc5 loc6)
    (connected loc6 loc7)
    (connected loc7 loc1)

    ;; Free locations
    ;; - Locations where construction can begin are marked as free.
    (free loc2)
    (free loc3)
    (free loc4)
    (free loc5)
    (free loc6)
    (free loc7)

    ;; Resource locations
    ;; - Resources are scattered across the map and must be collected by workers.
    (resource-at metal loc2)
    (resource-at energy loc3)
    (resource-at crystal loc4)
    (resource-at water loc6)
    (resource-at oxygen loc7)

    ;; Worker initial states
    ;; - Workers are placed at different starting locations and are available for tasks.
    (at-location worker1 loc1)
    (at-location worker2 loc5)
    (at-location worker3 loc6)
    (worker-available worker1)
    (worker-available worker2)
    (worker-available worker3)

    ;; Building resource requirements
    ;; - Specifies the type of resource required to complete each building.
    (needs solar-panel energy)
    (needs habitat metal)
    (needs laboratory crystal)
    (needs oxygen-generator water)
    (needs farm oxygen)
  )

  ;;; Goal
  ;;   - All buildings must be completed.
  ;;   - Buildings must be located at their designated locations.
  (:goal
    (and
      ;; Completion of all buildings
      (building-complete solar-panel)
      (building-complete habitat)
      (building-complete laboratory)
      (building-complete oxygen-generator)
      (building-complete farm)

      ;; Placement requirements for buildings
      ;; - Each building must be at a specific location after completion.
      (at-location solar-panel loc2)
      (at-location habitat loc3)
      (at-location laboratory loc4)
      (at-location oxygen-generator loc6)
      (at-location farm loc7)
    )
  )
)
