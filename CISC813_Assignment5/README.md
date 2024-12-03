
# Electronics Manufacturing Domain in PDDL

### Course: CISC813 - Automated Planning  
### Assignment: 5  
### Author: Amir Shetaia  
### Email: a.shetaia@queensu.ca  

---

## Table of Contents
- [Electronics Manufacturing Domain in PDDL](#electronics-manufacturing-domain-in-pddl)
    - [Course: CISC813 - Automated Planning](#course-cisc813---automated-planning)
    - [Assignment: 5](#assignment-5)
    - [Author: Amir Shetaia](#author-amir-shetaia)
    - [Email: a.shetaia@queensu.ca](#email-ashetaiaqueensuca)
  - [Table of Contents](#table-of-contents)
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
      - [4. **Durative Actions**](#4-durative-actions)
    - [Instance File: `problem.pddl`](#instance-file-problempddl)
      - [1. **Objects**](#1-objects)
      - [2. **Initial State**](#2-initial-state)
      - [3. **Goal State**](#3-goal-state)
      - [4. **Metric**](#4-metric)
  - [How to Run](#how-to-run)
  - [Assumptions and Considerations](#assumptions-and-considerations)
  - [Further Improvements](#further-improvements)

---

## Introduction

This project models the processes within an **electronics manufacturing facility** using **PDDL (Planning Domain Definition Language)**. The domain includes mobile robots for transporting components, various machines for processing, and workstations that manage operations such as assembly, testing, painting, and packaging.

---

## Problem Statement

The objective of the problem is to move multiple components through different workstations while managing the availability of machines and robot battery levels. Robots transport components between locations, perform operations using specific machines, and recharge when necessary. The goal is to ensure all components are fully processed and robots return to storage, minimizing the total time (makespan).

---

## Domain Structure

The **electronics manufacturing domain** focuses on resource management, with actions involving robots and machines. Robots move components through various manufacturing stages, and battery levels are tracked to ensure efficient operations. Machines process components, with actions restricted to the appropriate workstations.

### Features:
- **Robots**: Transport components between locations and recharge when necessary.
- **Components**: Go through assembly, testing, painting, and packaging stages.
- **Machines**: Specific machines are assigned to each operation.
- **Workstations**: Different locations with specialized roles (e.g., assembly, testing).
- **Battery Management**: Robots consume battery power during transport and require recharging at maintenance stations.

---

## Instance Structure

The **electronics_manufacturing_p1** instance models a specific scenario where two robots and five components interact within the manufacturing facility.

### Key Components:
- **Locations**: {storage, assembly-station, testing-station, painting-station, packaging-station, maintenance-station}.
- **Robots**: {robot1, robot2}.
- **Components**: {component1, component2, component3, component4, component5}.
- **Machines**: {assembler, tester, painter, packager}.
- **Processing Times**: Each machine has a defined processing time (e.g., 8 time units for assembly).
- **Goal**: Ensure that all components are packaged and robots return to the storage area.

---

## Code Explanation

### Domain File: `domain.pddl`

#### 1. **Types**
```lisp
(:types 
    location    ; Workstations and storage areas.
    robot       ; Mobile robots for transporting components.
    component   ; Materials or partially assembled products.
    machine     ; Base type for all machines.
    assembler tester painter packager - machine ; Specialized machines.
)
```
Defines the types used in the domain, including specialized machines for different processes.

#### 2. **Predicates**
```lisp
(:predicates
    (robot-at ?r - robot ?l - location)
    (component-at ?c - component ?l - location)
    (machine-at ?m - machine ?l - location)
    (machine-available ?m - machine)
    (connected ?l1 ?l2 - location)
    (assembled ?c - component)
    (tested ?c - component)
    (painted ?c - component)
    (packaged ?c - component)
)
```
Defines predicates to track the state of robots, components, and machines, as well as the relationships between locations.

#### 3. **Functions**
```lisp
(:functions
    (battery-level ?r - robot) ; Tracks robot battery levels.
    (processing-time ?m - machine) ; Processing time required for each machine.
)
```
Tracks dynamic values such as robot battery levels and machine processing times.

#### 4. **Durative Actions**
- **move-robot**: Models the movement of robots between connected locations.
- **transport-component**: Simulates transporting components between locations.
- **assemble-component**: Assembles a component at the assembly station.
- **test-component**: Tests a component at the testing station.
- **paint-component**: Paints a component at the painting station.
- **package-component**: Packages a component at the packaging station.
- **recharge-robot**: Recharges a robot at the maintenance station.

---

### Instance File: `problem.pddl`

#### 1. **Objects**
```lisp
(:objects
    storage assembly-station testing-station painting-station 
    packaging-station maintenance-station - location
    robot1 robot2 - robot
    component1 component2 component3 component4 component5 - component
    assembler - assembler
    tester - tester
    painter - painter
    packager - packager
)
```
Defines the specific objects for the problem instance, including locations, robots, components, and machines.

#### 2. **Initial State**
```lisp
(:init
    (robot-at robot1 storage)
    (robot-at robot2 storage)
    (= (battery-level robot1) 55)
    (= (battery-level robot2) 55)
    (component-at component1 storage)
    (component-at component2 storage)
    ...
    (machine-available assembler)
    (= (processing-time assembler) 8)
    ...
)
```
Specifies the initial state of the world, including the location of robots and components, robot battery levels, and machine availability.

#### 3. **Goal State**
```lisp
(:goal
    (and
        (packaged component1)
        (packaged component2)
        (packaged component3)
        (packaged component4)
        (packaged component5)
        (robot-at robot1 storage)
        (robot-at robot2 storage)
    )
)
```
Defines the desired end state: All components must be packaged, and robots must return to storage.

#### 4. **Metric**
```lisp
(:metric minimize (total-time))
```
The objective is to minimize the **makespan**—the total time required to complete all tasks.

---

## How to Run

1. Place `domain.pddl` and `problem.pddl` in the appropriate directory.
2. Run the planner with the following command:
   ```bash
   optic -T -N domain.pddl problem.pddl
   ```
3. Analyze the output to verify if the goal state was achieved within minimal time.

---

## Assumptions and Considerations

- **Robot Battery Levels**: Robots deplete battery during movement and need recharging.
- **Machine Availability**: Machines can only process components when available.
- **Sequential Operations**: Components must go through stages in order (assembly, testing, painting, packaging).
- **Parallel Operations**: Multiple robots can operate concurrently if resources allow.

---

## Further Improvements

- **Dynamic Battery Consumption**: Adjust battery usage based on the distance between locations.
- **Resource Allocation Strategy**: Prioritize components based on deadlines.
- **Additional Maintenance Constraints**: Introduce wear-and-tear on machines, requiring occasional maintenance.