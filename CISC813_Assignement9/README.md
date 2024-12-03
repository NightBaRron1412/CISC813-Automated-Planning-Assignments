
# Space Colony Builder in PDDL

### Course: CISC813 - Automated Planning

### Assignment: 9 - STRIPS Planning (Assignment 1 Modelling)

### Author: Amir Shetaia

### Email: a.shetaia@queensu.ca

---

## Table of Contents

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
      - [3. **Actions**](#3-actions)
    - [Instance File: `problem.pddl`](#instance-file-problempddl)
      - [1. **Objects**](#1-objects)
      - [2. **Initial State**](#2-initial-state)
      - [3. **Goal State**](#3-goal-state)
  - [How to Run](#how-to-run)
  - [Assumptions and Considerations](#assumptions-and-considerations)
  - [Further Improvements](#further-improvements)

---

## Introduction

This project models a **space colony construction system** using **STRIPS-based PDDL**. The focus is on resource collection, worker coordination, and efficient construction of buildings to expand a functional colony in space.

The **space colony builder domain** is designed to simulate complex construction planning with multiple workers and resources, requiring strategic task management to achieve the desired goals.

---

## Problem Statement

The objective is to coordinate workers to collect resources and construct buildings across multiple locations in a space colony. Resources are distributed across the map, and workers must navigate, collect the resources, and build structures at specified locations while adhering to constraints on location availability and worker assignments.

The problem introduces complexities such as multi-resource requirements for buildings, dependencies between buildings, and efficient navigation across a connected map. The overall goal is to optimize resource usage and complete all constructions efficiently.

---

## Domain Structure

The **space colony builder domain** models the interactions between workers, resources, and building locations. It includes the following key features:

### Features:

- **Workers**: Represent agents responsible for performing tasks such as collecting resources and constructing buildings.
- **Resources**: Materials such as `metal`, `energy`, and `crystal` required for constructing buildings.
- **Buildings**: Structures to be built, each requiring specific resources and designated locations.
- **Location Map**: Represents a graph-like structure connecting different locations in the space colony.

The domain includes **predicates** for tracking worker states, resource locations, and building progress, as well as **actions** for moving workers, collecting resources, and constructing buildings.

---

## Instance Structure

The **space colony problem** instance defines the initial configuration of the colony map, workers, resources, and buildings to be constructed.

### Key Components:

- **Workers**: Three workers (`worker1`, `worker2`, `worker3`) with different initial locations.
- **Locations**: Seven locations (`loc1` to `loc7`) connected in a circular layout with additional cross-links for efficiency.
- **Resources**: Five resources (`metal`, `energy`, `crystal`, `water`, `oxygen`) scattered across different locations.
- **Buildings**: Five buildings (`solar-panel`, `habitat`, `laboratory`, `oxygen-generator`, `farm`) to be constructed, each with specific resource requirements and placement constraints.

---

## Code Explanation

### Domain File: `domain.pddl`

#### 1. **Types**

Defines the types used in the domain:

```lisp
(:types location resource building worker)
```

#### 2. **Predicates**

Tracks the state of workers, resources, and buildings. Examples include:

```lisp
(connected ?l1 ?l2 - location) ; Locations are connected
(at-location ?x - (either worker building) ?l - location) ; Tracks location
(free ?l - location) ; Indicates if a location is free for construction
(building-complete ?b - building) ; Building is fully constructed
```

#### 3. **Actions**

- **move-worker**: Allows a worker to move between connected locations.
- **collect-resource**: Enables a worker to collect a resource from a specific location.
- **start-building**: Initiates the construction of a building at a location.
- **complete-building**: Finalizes the construction of a building using collected resources.

Each action includes **preconditions** and **effects** to manage state changes during planning.

---

### Instance File: `problem.pddl`

#### 1. **Objects**

Defines the objects in the problem instance:

```lisp
(:objects
    loc1 loc2 loc3 loc4 loc5 loc6 loc7 - location
    worker1 worker2 worker3 - worker
    metal energy crystal water oxygen - resource
    solar-panel habitat laboratory oxygen-generator farm - building
)
```

#### 2. **Initial State**

Specifies the initial setup, including:
- **Map connections**: Defines how locations are connected.
- **Worker states**: Tracks initial locations and availability.
- **Resource locations**: Indicates where resources are distributed.
- **Building requirements**: Specifies resource needs for each building.

#### 3. **Goal State**

Defines the completion criteria for the problem:

```lisp
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
```

---

## How to Run

1. Save the domain file (`domain.pddl`) and problem file (`problem.pddl`) in the same directory.
2. Use a PDDL planner (e.g., **LAMA** or **LAMA-FIRST**) to solve the problem.
   ```bash
   lama domain.pddl problem.pddl
   ```
3. Verify the output plan and ensure it satisfies the goals.

---

## Assumptions and Considerations

- **Worker Assignment**: Each worker can only perform one task at a time.
- **Location Constraints**: Buildings can only be constructed at free locations.
- **Resource Constraints**: Workers must collect resources before starting construction.

---

## Further Improvements

- **Dynamic Worker Allocation**: Assign workers dynamically based on proximity to tasks.
- **Path Optimization**: Minimize worker travel time using heuristics.
- **Scalability**: Test with larger maps, more workers, and additional resources.
