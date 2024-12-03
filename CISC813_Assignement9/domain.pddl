;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Domain: Space Colony Builder
; Description: Models the construction of a space colony, focusing on resource 
;              management and worker coordination to build essential structures.
; Author: Amir Shetaia
; Class: CISC813 - Automated Planning
; Email: a.shetaia@queensu.ca
; Assignment: 9 (Assignment 1 Modelling)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain space-colony-builder)
  (:requirements :strips :negative-preconditions :typing)

  ;;; Types
  ;; - location: Represents different areas in the space colony.
  ;; - resource: Represents materials used in construction.
  ;; - building: Represents the structures to be built in the colony.
  ;; - worker: Represents the workers who perform construction tasks.
  (:types
    location resource building worker
  )

  ;;; Predicates
  ;; - connected: Indicates if two locations are connected on the map.
  ;; - at-location: Tracks the current location of an entity (worker or building).
  ;; - free: Indicates if a location is available for construction.
  ;; - resource-at: Indicates the presence of a resource at a specific location.
  ;; - has-resource: Tracks if a worker is carrying a specific resource.
  ;; - has-resource2: Tracks if a worker is carrying a second resource (for multi-resource buildings).
  ;; - building-complete: Indicates if a building has been fully constructed.
  ;; - building-started: Indicates if a building is under construction.
  ;; - needs: Specifies a resource required by a building.
  ;; - needs2: Specifies a second resource required by a building.
  ;; - requires-building: Specifies a dependency where a building cannot be started until another is complete.
  ;; - worker-available: Tracks if a worker is free to perform tasks.
  ;; - worker-assigned: Tracks if a worker is assigned to a specific building.
  (:predicates
    (connected ?l1 ?l2 - location) ; Locations are connected
    (at-location ?x - (either worker building) ?l - location) ; Entity is at a location
    (free ?l - location) ; Location is available for construction
    (resource-at ?r - resource ?l - location) ; Resource is present at a location
    (has-resource ?w - worker ?r - resource) ; Worker has a specific resource
    (has-resource2 ?w - worker ?r - resource) ; Worker has a second resource
    (building-complete ?b - building) ; Building is fully constructed
    (building-started ?b - building) ; Building is under construction
    (needs ?b - building ?r - resource) ; Building requires a specific resource
    (needs2 ?b - building ?r - resource) ; Building requires a second resource
    (requires-building ?b - building ?req - building) ; Building depends on another building
    (worker-available ?w - worker) ; Worker is free for tasks
    (worker-assigned ?w - worker ?b - building) ; Worker is assigned to a building
  )

  ;;; Actions

  ; Action: move-worker
  ;; - Moves a worker between two connected locations.
  (:action move-worker
    :parameters (?w - worker ?from ?to - location)
    :precondition (and
      (at-location ?w ?from)
      (connected ?from ?to)
      (worker-available ?w)
    )
    :effect (and
      (not (at-location ?w ?from))
      (at-location ?w ?to)
    )
  )

  ; Action: collect-resource
  ;; - Allows a worker to collect a resource from a location.
  (:action collect-resource
    :parameters (?w - worker ?r - resource ?l - location)
    :precondition (and
      (at-location ?w ?l)
      (resource-at ?r ?l)
      (worker-available ?w)
      (not (has-resource ?w ?r))
    )
    :effect (and
      (has-resource ?w ?r)
      (not (resource-at ?r ?l))
    )
  )

  ; Action: collect-resource2
  ;; - Allows a worker to collect a second resource for buildings that need multiple resources.
  (:action collect-resource2
    :parameters (?w - worker ?r - resource ?l - location)
    :precondition (and
      (at-location ?w ?l)
      (resource-at ?r ?l)
      (worker-available ?w)
      (not (has-resource ?w ?r))
      (not (has-resource2 ?w ?r))
    )
    :effect (and
      (has-resource2 ?w ?r)
      (not (resource-at ?r ?l))
    )
  )

  ; Action: start-building
  ;; - Starts construction of a building at a specific location.
  (:action start-building
    :parameters (?w - worker ?b - building ?l - location)
    :precondition (and
      (at-location ?w ?l)
      (worker-available ?w)
      (free ?l)
      (not (building-started ?b))
    )
    :effect (and
      (building-started ?b)
      (worker-assigned ?w ?b)
      (not (worker-available ?w))
      (not (free ?l))
      (at-location ?b ?l)
    )
  )

  ; Action: start-building-with-dependency
  ;; - Starts a building that requires another building to be completed first.
  (:action start-building-with-dependency
    :parameters (?w - worker ?b - building ?l - location ?req - building)
    :precondition (and
      (at-location ?w ?l)
      (worker-available ?w)
      (free ?l)
      (not (building-started ?b))
      (requires-building ?b ?req)
      (building-complete ?req)
    )
    :effect (and
      (building-started ?b)
      (worker-assigned ?w ?b)
      (not (worker-available ?w))
      (not (free ?l))
      (at-location ?b ?l)
    )
  )

  ; Action: complete-building
  ;; - Completes a building that requires one resource.
  (:action complete-building
    :parameters (?w - worker ?b - building ?l - location ?r - resource)
    :precondition (and
      (building-started ?b)
      (worker-assigned ?w ?b)
      (has-resource ?w ?r)
      (needs ?b ?r)
      (at-location ?w ?l)
      (at-location ?b ?l)
      (not (building-complete ?b))
    )
    :effect (and
      (building-complete ?b)
      (not (has-resource ?w ?r))
      (not (worker-assigned ?w ?b))
      (worker-available ?w)
    )
  )

  ; Action: complete-building-two-resources
  ;; - Completes a building that requires two different resources.
  (:action complete-building-two-resources
    :parameters (?w - worker ?b - building ?l - location ?r1 ?r2 - resource)
    :precondition (and
      (building-started ?b)
      (worker-assigned ?w ?b)
      (has-resource ?w ?r1)
      (has-resource2 ?w ?r2)
      (needs ?b ?r1)
      (needs2 ?b ?r2)
      (at-location ?w ?l)
      (at-location ?b ?l)
      (not (building-complete ?b))
    )
    :effect (and
      (building-complete ?b)
      (not (has-resource ?w ?r1))
      (not (has-resource2 ?w ?r2))
      (not (worker-assigned ?w ?b))
      (worker-available ?w)
    )
  )
)
