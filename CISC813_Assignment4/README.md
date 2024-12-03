# Epidemic Control Domain in RDDL

### Course: CISC813 - Automated Planning  
### Assignment: 4  
### Author: Amir Shetaia  
### Email: a.shetaia@queensu.ca  

---

## Table of Contents
- [Epidemic Control Domain in RDDL](#epidemic-control-domain-in-rddl)
    - [Course: CISC813 - Automated Planning](#course-cisc813---automated-planning)
    - [Assignment: 4](#assignment-4)
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
    - [Domain File: `domain.rddl`](#domain-file-domainrddl)
      - [1. **Types**](#1-types)
      - [2. **Pvariables**](#2-pvariables)
      - [3. **CPFs**](#3-cpfs)
      - [4. **Reward**](#4-reward)
    - [Instance File: `instance.rddl`](#instance-file-instancerddl)
      - [1. **Objects**](#1-objects)
      - [2. **Non-fluents**](#2-non-fluents)
      - [3. **Init-state**](#3-init-state)
      - [4. **Horizon and Discount Factor**](#4-horizon-and-discount-factor)
  - [How to Run](#how-to-run)
  - [Assumptions and Considerations](#assumptions-and-considerations)
  - [Further Improvements](#further-improvements)

---

## Introduction

This project models the spread of an epidemic across multiple interconnected regions, incorporating key features such as vaccination strategies, hospital capacity management, and movement restrictions between regions. The domain and instance are written in **Relational Dynamic Influence Diagram Language (RDDL)**.

---

## Problem Statement

In this problem, the goal is to manage epidemic spread across multiple regions while optimizing hospital resources and intervention strategies such as vaccination and movement restrictions. The simulation seeks to minimize infection rates while considering the constraints on healthcare resources and the costs of interventions.

---

## Domain Structure

The **epidemic_control** domain models the dynamics of disease spread, hospital management, and the application of interventions such as vaccinations and movement restrictions. It includes state variables representing different segments of the population (e.g., infected, susceptible, recovered), hospitals, and intermediate fluents such as infection rate and hospital load.

### Features:
- **Regions**: Geographical areas where the epidemic spreads.
- **Hospitals**: Facilities that manage the healthcare load of the epidemic.
- **Actions**: Vaccination, movement restriction, and adding hospital beds.
- **State Variables**: Susceptible, infected, recovered, vaccinated populations.
- **Reward Function**: Penalizes high infection rates and costly interventions.

---

## Instance Structure

The **epidemic_instance_1** defines a specific scenario involving 4 regions and 3 hospitals. Each region has a unique population size and initial condition (number of susceptible and infected individuals). Hospitals serve specific regions and have base capacities.

### Key Components:
- **Regions**: {r1, r2, r3, r4}
- **Hospitals**: {h1, h2, h3}
- **Adjacency**: Defines connections between regions to model disease spread.
- **Initial State**: Specifies the initial number of susceptible and infected individuals.
- **Horizon**: The simulation runs over 35 decision-making steps.
- **Discount Factor**: A discount factor of 0.95 is used to weigh future rewards.

---

## Code Explanation

### Domain File: `domain.rddl`

#### 1. **Types**
```rddl
types {
    region: object;
    hospital: object;
};
```
Defines two main object types: `region` and `hospital`.

#### 2. **Pvariables**
```rddl
pvariables {
    ADJACENT(region, region): { non-fluent, bool, default = false };
    HOSPITAL_CAPACITY(hospital): { non-fluent, real, default = 100.0 };
    POPULATION(region): { non-fluent, real, default = 10000.0 };
    susceptible(region): { state-fluent, real, default = 9900.0 };
    infected(region): { state-fluent, real, default = 100.0 };
    hospitalized(hospital): { state-fluent, real, default = 0.0 };
    vaccinate(region): { action-fluent, real, default = 0.0 };
    restrict_movement(region): { action-fluent, bool, default = false };
};
```
Defines key variables used in the domain including non-fluents for fixed properties like `ADJACENT`, state-fluents for the dynamic state of the world such as `susceptible`, and action-fluents for available actions such as `vaccinate`.

#### 3. **CPFs**
```rddl
cpfs {
    infection_rate(?r) = 0.3 * infected(?r) / POPULATION(?r) * 
                         if (restrict_movement(?r)) then 0.5 else 1.0;
    susceptible'(?r) = max[0, susceptible(?r) - (infection_rate(?r) * susceptible(?r)) - vaccinate(?r)];
};
```
The conditional probability functions define how the infection rate is computed and how the number of susceptible individuals is updated based on infection rates and vaccination efforts.

#### 4. **Reward**
```rddl
reward = [sum_{?r: region} [-0.1 * infected(?r)]] + 
         [sum_{?r: region} [-10.0 * if (restrict_movement(?r)) then 1.0 else 0.0]] +
         [sum_{?h: hospital} [-1.0 * add_hospital_beds(?h)]] +
         [sum_{?r: region} [-0.5 * vaccinate(?r)]];
```
The reward function penalizes high infection rates, movement restrictions, expanding hospital capacity, and vaccination, reflecting the cost of these interventions.

---

### Instance File: `instance.rddl`

#### 1. **Objects**
```rddl
objects {
    region: {r1, r2, r3, r4};
    hospital: {h1, h2, h3};
};
```
Defines the specific regions and hospitals in this instance.

#### 2. **Non-fluents**
```rddl
non-fluents {
    ADJACENT(r1, r2) = true;
    HOSPITAL_CAPACITY(h1) = 120.0;
    POPULATION(r1) = 12000.0;
};
```
Defines the relationships between regions, the capacities of hospitals, and the population sizes for each region.

#### 3. **Init-state**
```rddl
init-state {
    susceptible(r1) = 11800.0;
    infected(r1) = 200.0;
    hospitalized(h1) = 20.0;
};
```
Specifies the initial number of susceptible and infected individuals in each region, and the number of people already hospitalized.

#### 4. **Horizon and Discount Factor**
```rddl
horizon = 35;
discount = 0.95;
```
Defines the simulation horizon (number of steps) and discount factor for future rewards.

---

## How to Run

1. Ensure that the RDDL environment is set up.
2. Place the `domain.rddl` and `instance.rddl` files in the appropriate directory.
3. Run the planner/solver that supports RDDL with the specified instance and domain files.
4. Analyze the results of the simulation to evaluate the effectiveness of various control strategies.

---

## Assumptions and Considerations

- **Infection Spread**: Assumes a basic infection model where the spread is proportional to the current infected population and interactions between regions.
- **Hospital Management**: Each hospital serves specific regions, and hospital loads are calculated based on current hospitalizations.
- **Vaccination and Movement Restrictions**: Both are costly but effective interventions to reduce the spread of the epidemic.

---

## Further Improvements

- **Dynamic Population Growth**: Introduce births and deaths to model the changing population over time.
- **More Complex Disease Dynamics**: Include factors like varying infection rates across regions or age groups.
- **Resource Allocation**: Model limited availability of vaccines or hospital resources.