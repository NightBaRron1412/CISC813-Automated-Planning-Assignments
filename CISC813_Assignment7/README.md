# Warehouse Logistics HTN Planning in HDDL

### Course: CISC813 - Automated Planning

### Assignment: 7 - HTN Planning

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
    - [Domain File: `domain.hddl`](#domain-file-domainhddl)
      - [1. **Types**](#1-types)
      - [2. **Predicates**](#2-predicates)
      - [3. **Tasks and Methods**](#3-tasks-and-methods)
      - [4. **Actions**](#4-actions)
    - [Instance File: `problem.hddl`](#instance-file-problemhddl)
      - [1. **Objects**](#1-objects)
      - [2. **Initial State**](#2-initial-state)
      - [3. **Goal State**](#3-goal-state)
  - [How to Run](#how-to-run)
  - [Assumptions and Considerations](#assumptions-and-considerations)
  - [Further Improvements](#further-improvements)

---

## Introduction

This project models a **warehouse logistics system** using **Hierarchical Task Network (HTN) Planning** in **HDDL (Hierarchical Domain Definition Language)**. The focus is on optimizing package delivery throughout a warehouse using multiple robots while managing dynamic elements such as obstacles, robot maintenance, and the need for appropriate handling of different package types.

The **warehouse logistics domain** is designed to be versatile, enabling the modeling of complex logistics operations involving different types of robots and package properties. By utilizing HTN planning, tasks are decomposed into manageable subtasks, which can be executed in an efficient sequence, thus improving the overall performance of the warehouse operations.

---

## Problem Statement

The objective is to coordinate a fleet of robots to deliver multiple packages throughout a warehouse. Packages have varying properties (e.g., heavy, fragile, perishable) and must be handled by appropriately equipped robots. Robots are expected to navigate efficiently between warehouse locations, overcome obstacles, perform maintenance when required, and ensure that all packages are delivered to their final destinations.

The problem introduces complexities such as blocked paths, the need for maintenance of robots, and different requirements for package handling. These complexities need to be managed effectively to ensure that all delivery tasks are completed without issues. The overall goal is to find an optimal strategy that results in the successful and timely delivery of all packages.

---

## Domain Structure

The **warehouse logistics domain** models the interactions between robots, packages, and warehouse locations. The domain includes various elements such as robots with specific capabilities, different types of packages, and warehouse sections with direct or blocked connections.

### Features:

- **Robots**: Robots are the primary agents for executing actions within the domain. Each robot is defined with specific capabilities such as handling heavy packages, handling fragile packages, or being flame-resistant. These capabilities determine the tasks that a robot can undertake.
- **Packages**: Packages are defined with different properties, including heavy, fragile, flammable, perishable, and urgent. These properties dictate how they should be handled and which robots can deliver them.
- **Warehouse Layout**: The warehouse is divided into different sections, each representing a physical area such as `storage-area`, `loading-dock`, `section-a`, etc. Connections between locations are modeled to allow or restrict movement of robots.
- **Robot Maintenance**: Some robots may require periodic maintenance, which means that they cannot undertake tasks until their maintenance is completed. The maintenance aspect adds a layer of complexity to the planning process, requiring the system to schedule and handle maintenance efficiently.

The warehouse logistics domain also includes different tasks, methods, and actions that form the basis of HTN planning. Tasks are abstract goals that need to be achieved, while methods define how these tasks can be decomposed into smaller tasks or actions.

---

## Instance Structure

The **warehouse-problem** instance defines the specific configuration of the warehouse, including the initial placement of robots and packages, obstacles in the warehouse, and the delivery goals for each package.

### Key Components:

- **Packages**: Seven packages (`pkg1` to `pkg7`) are distributed throughout the warehouse. Each package has unique properties, such as being heavy, fragile, perishable, or flammable, which affects which robot can transport it.
- **Robots**: Four robots (`robot1` to `robot4`) are available, with varied capabilities. Some robots are capable of handling heavy or fragile packages, while others may require maintenance before they can be deployed.
- **Locations**: The warehouse is divided into different sections, each represented as a location. The `storage-area`, `loading-dock`, `maintenance-bay`, and `sections A-E` are all modeled as distinct locations that robots can move between.
- **Goal**: The main objective is to deliver all packages to their respective destinations. Each package has a specific destination location, and the robots must deliver them while adhering to all constraints and overcoming any challenges (e.g., blocked paths or maintenance requirements).

---

## Code Explanation

### Domain File: `domain.hddl`

#### 1. **Types**

```lisp
(:types
    location package robot - object
)
```
Defines the types used in the domain. Robots, packages, and locations are all subtypes of the main type `object`. This helps in organizing the problem into manageable entities.

#### 2. **Predicates**

```lisp
(:predicates
    (connected ?l1 ?l2 - location) ; Locations are connected
    (at ?e - object ?l - location) ; Object is at a location
    (has ?r - robot ?p - package) ; Robot has a package
    (available ?r - robot) ; Robot is available
    (needs-maintenance ?r - robot) ; Robot needs maintenance
    (delivered ?p - package) ; Package has been delivered
    ...
)
```
Defines the predicates to track the state of robots, packages, locations, and the overall environment. Predicates are fundamental components that express the relationships between different objects and the conditions in the domain.

#### 3. **Tasks and Methods**

- **Tasks**: These are high-level objectives that must be achieved. Examples include `deliver-packages` (delivering all packages) and `move-to` (moving a robot to a particular location). Tasks are abstract in nature and do not specify the exact sequence of actions to be taken.
- **Methods**: Methods define how tasks can be achieved by decomposing them into smaller subtasks. For example, the method `m_deliver-all` recursively breaks down the task of delivering all packages into individual delivery tasks.
  - Example method:
    ```lisp
    (:method m_deliver-all
        :task (deliver-packages)
        :precondition (exists (?p - package) (not (delivered ?p)))
        :ordered-subtasks (...)
    )
    ```
    The above method continues the delivery task until all packages are successfully delivered.

#### 4. **Actions**

- **Movement Actions**: Actions like `move` allow a robot to move between connected locations. This requires a precondition that the two locations are connected and the path is not blocked.
- **Handling Actions**: Actions such as `pickup-package` and `dropoff-package` define how a robot can pick up a package at a location and then deliver it to the destination.
- **Maintenance Actions**: Actions such as `maintenance-action` are used to perform maintenance on robots when required. These actions ensure that a robot is in working condition before it resumes operations.

---

### Instance File: `problem.hddl`

#### 1. **Objects**

```lisp
(:objects
    pkg1 pkg2 pkg3 pkg4 pkg5 pkg6 pkg7 - package
    robot1 robot2 robot3 robot4 - robot
    storage-area loading-dock section-a section-b section-c section-d section-e obstacle-area maintenance-bay - location
)
```
Defines the objects in the instance. Packages, robots, and locations are clearly specified to create a concrete instance of the warehouse logistics problem.

#### 2. **Initial State**

The initial state includes the following:
- **Robot Locations**: Specifies where each robot is located at the beginning of the problem.
- **Package Properties**: Indicates which packages are heavy, fragile, perishable, or flammable, and where they are initially located.
- **Blocked Paths**: Specifies areas in the warehouse that are initially blocked, affecting the movement of robots.
- **Robot Capabilities**: Indicates which robots are capable of handling heavy, fragile, or flammable packages.
- **Maintenance Needs**: Indicates that certain robots may require maintenance, which prevents them from being available until maintenance is completed.

#### 3. **Goal State**

```lisp
(:goal
    (and
        (delivered pkg1)
        (delivered pkg2)
        (delivered pkg3)
        (delivered pkg4)
        (delivered pkg5)
        (delivered pkg6)
        (delivered pkg7)
    )
)
```
The goal is for all packages to be delivered to their specified destinations. The delivery must be completed in an efficient manner while adhering to all constraints such as package handling requirements and maintenance needs.

---

## How to Run

1. Place the domain file (`domain.hddl`) and the problem file (`problem.hddl`) in the same directory.
2. Use an HTN-capable planner to run the problem, such as `panada` or an equivalent.
   ```bash
   panada-viz domain.hddl problem.hddl
   ```
3. Verify the output to ensure all packages are delivered successfully and robots perform tasks efficiently. Note that the URL outputted by the planner can be quite long due to the complexity of the domain and problem files, and you may encounter some issues when attempting to open it.

---

## Assumptions and Considerations

- **Robot Capabilities**: Each robot is assigned specific capabilities for handling different types of packages. For instance, some robots can handle heavy packages while others cannot.
- **Maintenance Requirements**: Some robots may need maintenance and cannot be used until maintenance is performed. This prevents them from undertaking tasks until they are available.
- **Blocked Paths**: Certain paths may be blocked initially, which may require robots to take alternative routes or clear the obstacles before proceeding.
- **Urgency and Prioritization**: Packages marked as `urgent` need to be prioritized in the delivery sequence. The HTN planning methods are designed to choose such packages first.
- **Dynamic Replanning**: While the current model is pre-planned, future versions could incorporate dynamic replanning to handle unexpected events such as additional obstacles or robot failures.

---

## Further Improvements

- **Dynamic Assignment**: Enhance the package assignment strategy to dynamically allocate packages based on real-time conditions (e.g., robot availability, proximity to packages, or battery level).
- **Path Optimization**: Improve robot navigation to reduce overall travel distance and time, avoiding congested or blocked areas in the warehouse to enhance efficiency.
- **Energy Management**: Incorporate energy management strategies to ensure that robots manage their power efficiently, including recharging when needed and optimizing power consumption.
- **Obstacle Management**: Develop advanced strategies for managing obstacles, including predictive obstacle avoidance and dynamic pathfinding, to further enhance robot efficiency.
- **Robust Maintenance Scheduling**: Implement a more sophisticated maintenance scheduling mechanism that takes into account each robot's workload and availability to minimize downtime and maximize overall efficiency.
- **Human Interaction**: Introduce human-robot interaction scenarios where human workers may assist robots in specific tasks, such as clearing blockages or handling extremely fragile packages.
- **Scalability Testing**: Conduct extensive testing with larger numbers of robots and packages to evaluate the scalability of the domain and identify potential bottlenecks in the planning process.

