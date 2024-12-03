;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Problem: Two Vessels
; Description: Models a scenario where two vessels undergo heating
;              and cooling without pressure management.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (problem two-vessels)
    (:domain multi-vessel-process)

    ;;; Objects
    ;; - vessel1, vessel2: The two vessels used in the process.
    ;; - heater1, heater2, cooler1, cooler2: Heating and cooling devices assigned to each vessel.
    (:objects
        vessel1 vessel2 - vessel
        heater1 heater2 - heater
        cooler1 cooler2 - cooler
    )

    ;;; Initial State
    (:init
        ; Initial completion status for each phase and process
        (not (phase1-complete vessel1))
        (not (phase2-complete vessel1))
        (not (process-complete vessel1))

        (not (phase1-complete vessel2))
        (not (phase2-complete vessel2))
        (not (process-complete vessel2))

        ; Initial state of devices
        ;; All heaters and coolers are initially turned off.
        (not (heater-on heater1 vessel1))
        (not (heater-on heater2 vessel2))
        (not (cooler-on cooler1 vessel1))
        (not (cooler-on cooler2 vessel2))

        ; Initial temperature for each vessel (room temperature)
        (= (temperature vessel1) 25.0)
        (= (temperature vessel2) 25.0)

        ; Phase target temperatures for each vessel
        ;; Specifies the target temperature for each phase for vessel1 and vessel2.
        (= (phase1-target vessel1) 50.0)
        (= (phase2-target vessel1) 30.0)
        (= (phase1-target vessel2) 55.0)
        (= (phase2-target vessel2) 35.0)

        ; Time requirements for each phase
        ;; Each phase requires a specific time to complete.
        (= (phase1-time vessel1) 0.0)
        (= (phase2-time vessel1) 0.0)
        (= (required-time vessel1) 5.0)

        (= (phase1-time vessel2) 0.0)
        (= (phase2-time vessel2) 0.0)
        (= (required-time vessel2) 4.0)

        ; Device rates for heating and cooling
        ;; Defines the rate at which each heater and cooler changes temperature.
        (= (heating-rate heater1) 2.0)
        (= (heating-rate heater2) 2.0)
        (= (cooling-rate cooler1) 2.0)
        (= (cooling-rate cooler2) 2.0)
    )

    ;;; Goal State
    ;; The goal is to complete the process for both vessels.
    (:goal
        (and
            (process-complete vessel1)
            (process-complete vessel2)
        )
    )
)