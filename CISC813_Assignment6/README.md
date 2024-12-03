# Multi-Vessel Chemical Process Domain in PDDL

### Course: CISC813 - Automated Planning

### Assignment: 6 - Hybrid Planning

### Author: Amir Shetaia

### Email: a.shetaia@queensu.ca

---

## Table of Contents

- [Multi-Vessel Chemical Process Domain in PDDL](#multi-vessel-chemical-process-domain-in-pddl)
  - [Course: CISC813 - Automated Planning](#course-cisc813---automated-planning)
  - [Assignment: 6 - Hybrid Planning](#assignment-6---hybrid-planning)
  - [Author: Amir Shetaia](#author-amir-shetaia)
  - [Email: a.shetaia@queensu.ca](#email-ashetaiaqueensuca)
  - [Introduction](#introduction)
  - [Problem Statement](#problem-statement)
  - [Domain Structure](#domain-structure)
    - [Features:](#features)
  - [Instance Structure](#instance-structure)
    - [Key Components:](#key-components)
  - [Code Explanation](#code-explanation)
    - [Domain File: `domain.pddl`](#domain-file-domainpddl)
      - [1. **Types**](#1-types)
      - [2. **Predicates**](#2-predicates)
      - [3. **Functions**](#3-functions)
      - [4. **Actions and Processes**](#4-actions-and-processes)
    - [Instance File: `problem.pddl`](#instance-file-problempddl)
      - [1. **Objects**](#1-objects)
      - [2. **Initial State**](#2-initial-state)
      - [3. **Goal State**](#3-goal-state)
  - [How to Run](#how-to-run)
  - [Assumptions and Considerations](#assumptions-and-considerations)
  - [Further Improvements](#further-improvements)

---

## Introduction

This project models a **multi-vessel chemical process** with two vessels that undergo controlled heating and cooling phases, designed using **PDDL (Planning Domain Definition Language)**. The focus is on temperature management without pressure control.

---

## Problem Statement

The objective of this problem is to process two vessels by guiding each through heating and cooling phases. Each vessel has defined target temperatures and time requirements for each phase, and the ultimate goal is to complete all phases while minimizing the total processing time.

---

## Domain Structure

The **multi-vessel process domain** includes heating and cooling mechanisms for temperature control and tracks each vessel's progress through the process phases.

### Features:

- **Vessels**: Represent containers for chemical processes.
- **Heating**: Heaters increase the vessel temperature in the heating phase.
- **Cooling**: Coolers reduce the temperature in the cooling phase.
- **Temperature Tracking**: The system maintains target temperatures and tracks time spent in each phase.

---

## Instance Structure

The **two-vessels** instance models a scenario where two vessels undergo heating and cooling with specific target temperatures and required times.

### Key Components:

- **Vessels**: {vessel1, vessel2}.
- **Heaters**: {heater1, heater2}.
- **Coolers**: {cooler1, cooler2}.
- **Target Temperatures**: Phase 1 requires heating to a specified target; Phase 2 requires cooling to a lower target.
- **Goal**: Complete both heating and cooling phases for each vessel.

---

## Code Explanation

### Domain File: `domain.pddl`

#### 1. **Types**

```lisp
(:types
    vessel device - object
    heater cooler - device
)
```

Defines the types used in the domain, including specialized devices for heating and cooling.

#### 2. **Predicates**

```lisp
(:predicates
    (heater-on ?h - heater ?v - vessel)
    (cooler-on ?c - cooler ?v - vessel)
    (phase1-complete ?v - vessel)
    (phase2-complete ?v - vessel)
    (process-complete ?v - vessel)
)
```

Defines predicates to track the state of heaters, coolers, and the completion of each phase.

#### 3. **Functions**

```lisp
(:functions
    (temperature ?v - vessel) ; Current temperature
    (phase1-time ?v - vessel) ; Time spent in phase 1
    (phase2-time ?v - vessel) ; Time spent in phase 2
    (phase1-target ?v - vessel) ; Target temperature for phase 1
    (phase2-target ?v - vessel) ; Target temperature for phase 2
    (heating-rate ?h - heater) ; Rate of heating by the heater
    (cooling-rate ?c - cooler) ; Rate of cooling by the cooler
    (required-time ?v - vessel) ; Time required for each phase
)
```

Tracks temperature, time, and rate values for each vessel and device.

#### 4. **Actions and Processes**

- **Actions**: Control actions include `activate-heater`, `deactivate-heater`, `activate-cooler`, and `deactivate-cooler` to manage device states.
- **Processes**: `heating` and `cooling` represent the continuous temperature changes over time for vessels.
- **Events**: Triggered events, such as `complete-phase1` and `complete-phase2`, mark the completion of phases when time requirements are met.

---

### Instance File: `problem.pddl`

#### 1. **Objects**

```lisp
(:objects
    vessel1 vessel2 - vessel
    heater1 heater2 - heater
    cooler1 cooler2 - cooler
)
```

Defines the vessels and devices for the problem instance.

#### 2. **Initial State**

```lisp
(:init
    (not (phase1-complete vessel1))
    (not (phase2-complete vessel1))
    (not (process-complete vessel1))
    ...
)
```

Specifies the initial state of the vessels and devices, including temperatures, time, and phase status.

#### 3. **Goal State**

```lisp
(:goal
    (and
        (process-complete vessel1)
        (process-complete vessel2)
    )
)
```

The goal is for both vessels to complete their processes.

---

## How to Run

1. Place `domain.pddl` (domain file) and `problem.pddl` (problem file) in the appropriate directory.
2. Run the planner with the following command:
   ```bash
   enhsp-2020 --domain domain.pddl --problem problem.pddl -pe
   ```
3. Analyze the output to ensure that both vessels completed their phases within minimal time.

---

## Assumptions and Considerations

- **Sequential Phase Completion**: Each vessel must complete Phase 1 before Phase 2.
- **Device Control**: Heaters and coolers can only operate if turned on and deactivated appropriately.

---

## Further Improvements

- **Dynamic Temperature Control**: Modify heating and cooling rates based on vessel characteristics.
- **Optimized Phase Times**: Introduce flexibility in phase durations to minimize energy usage.
