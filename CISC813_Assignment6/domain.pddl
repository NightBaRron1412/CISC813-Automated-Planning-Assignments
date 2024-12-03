;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Domain: Multi-Vessel Chemical Process
; Description: Models a chemical process with two vessels, focusing on 
;              heating and cooling phases without pressure management.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain multi-vessel-process)
    (:requirements :equality :negative-preconditions :typing :adl :fluents)

    ;;; Types
    ;; - vessel: Represents the chemical vessels undergoing heating and cooling.
    ;; - device: A general category for all devices, with subtypes heater and cooler.
    (:types
        vessel device - object
        heater cooler - device
    )

    ;;; Predicates
    ;; - heater-on, cooler-on: Tracks whether each device is active on a vessel.
    ;; - phase1-complete, phase2-complete, process-complete: Tracks the progress
    ;;   of each vessel through its heating and cooling phases.
    (:predicates
        (heater-on ?h - heater ?v - vessel)
        (cooler-on ?c - cooler ?v - vessel)
        (phase1-complete ?v - vessel)
        (phase2-complete ?v - vessel)
        (process-complete ?v - vessel)
    )

    ;;; Functions
    ;; - temperature: The current temperature of each vessel.
    ;; - phase1-time, phase2-time: Time spent in each heating or cooling phase.
    ;; - phase1-target, phase2-target: Target temperatures for each phase in each vessel.
    ;; - heating-rate, cooling-rate: Rates at which heaters and coolers change the temperature.
    ;; - required-time: Minimum time needed to complete each phase.
    (:functions
        (temperature ?v - vessel) ; Current temperature
        (phase1-time ?v - vessel) ; Time spent in phase 1
        (phase2-time ?v - vessel) ; Time spent in phase 2
        (phase1-target ?v - vessel) ; Target temperature for phase 1
        (phase2-target ?v - vessel) ; Target temperature for phase 2
        (heating-rate ?h - heater) ; Rate of heating by the heater
        (cooling-rate ?c - cooler) ; Rate of cooling by the cooler
        (required-time ?v - vessel) ; Time required to complete each phase
    )

    ;;; Actions

    ; Action: activate-heater
    ;; Activates the heater for a vessel if it hasn’t yet completed phase 1,
    ;; and if the vessel’s temperature is below the target for that phase.
    (:action activate-heater
        :parameters (?h - heater ?v - vessel)
        :precondition (and
            (not (heater-on ?h ?v))
            (not (phase1-complete ?v))
            (< (temperature ?v) (phase1-target ?v))
        )
        :effect (heater-on ?h ?v)
    )

    ; Action: deactivate-heater
    ;; Deactivates the heater once the vessel's temperature reaches the target
    ;; temperature for phase 1, ensuring heating stops once the target is met.
    (:action deactivate-heater
        :parameters (?h - heater ?v - vessel)
        :precondition (and
            (heater-on ?h ?v)
            (>= (temperature ?v) (phase1-target ?v))
        )
        :effect (not (heater-on ?h ?v))
    )

    ; Action: activate-cooler
    ;; Activates the cooler for a vessel once phase 1 is complete, and the
    ;; temperature exceeds the target for phase 2.
    (:action activate-cooler
        :parameters (?c - cooler ?v - vessel)
        :precondition (and
            (not (cooler-on ?c ?v))
            (phase1-complete ?v)
            (not (phase2-complete ?v))
            (> (temperature ?v) (phase2-target ?v))
        )
        :effect (cooler-on ?c ?v)
    )

    ; Action: deactivate-cooler
    ;; Deactivates the cooler when the temperature reaches the phase 2 target,
    ;; ensuring the vessel doesn’t cool below the required temperature.
    (:action deactivate-cooler
        :parameters (?c - cooler ?v - vessel)
        :precondition (and
            (cooler-on ?c ?v)
            (<= (temperature ?v) (phase2-target ?v))
        )
        :effect (not (cooler-on ?c ?v))
    )

    ;;; Processes

    ; Process: heating
    ;; Increases the temperature of the vessel when the heater is active.
    ;; The rate of temperature increase is defined by the heating-rate of the heater.
    (:process heating
        :parameters (?h - heater ?v - vessel)
        :precondition (heater-on ?h ?v)
        :effect (increase
            (temperature ?v)
            (* #t (heating-rate ?h)))
    )

    ; Process: cooling
    ;; Decreases the temperature of the vessel when the cooler is active.
    ;; The rate of temperature decrease is defined by the cooling-rate of the cooler.
    (:process cooling
        :parameters (?c - cooler ?v - vessel)
        :precondition (cooler-on ?c ?v)
        :effect (decrease
            (temperature ?v)
            (* #t (cooling-rate ?c)))
    )

    ; Process: phase1-progress
    ;; Tracks the time spent in phase 1 as long as the vessel’s temperature
    ;; is close to the target temperature within a tolerance of 5°C.
    (:process phase1-progress
        :parameters (?v - vessel)
        :precondition (and
            (not (phase1-complete ?v))
            (>= (temperature ?v) (- (phase1-target ?v) 5.0))
        )
        :effect (increase (phase1-time ?v) (* #t 1.0))
    )

    ; Process: phase2-progress
    ;; Tracks the time spent in phase 2 once phase 1 is complete, and the vessel’s
    ;; temperature has reached or is below the target for phase 2.
    (:process phase2-progress
        :parameters (?v - vessel)
        :precondition (and
            (phase1-complete ?v)
            (not (phase2-complete ?v))
            (<= (temperature ?v) (phase2-target ?v))
        )
        :effect (increase (phase2-time ?v) (* #t 1.0))
    )

    ;;; Events

    ; Event: complete-phase1
    ;; Marks phase 1 as complete once the required time has been reached for the vessel.
    (:event complete-phase1
        :parameters (?v - vessel)
        :precondition (and
            (not (phase1-complete ?v))
            (>= (phase1-time ?v) (required-time ?v))
        )
        :effect (phase1-complete ?v)
    )

    ; Event: complete-phase2
    ;; Marks both phase 2 and the overall process as complete once the
    ;; required time has been reached for phase 2.
    (:event complete-phase2
        :parameters (?v - vessel)
        :precondition (and
            (phase1-complete ?v)
            (not (phase2-complete ?v))
            (>= (phase2-time ?v) (required-time ?v))
        )
        :effect (and
            (phase2-complete ?v)
            (process-complete ?v)
        )
    )
)