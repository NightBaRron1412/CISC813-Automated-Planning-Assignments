
# Undercity Intrigue: Epistemic Planning Inspired by Arcane

### Course: CISC813 - Automated Planning

### Assignment: 8 - Epistemic Planning

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
  - [Problem File: `Problem.pdkbddl`](#problem-file-problempdkbddl)
    - [1. **Types**](#1-types)
    - [2. **Predicates**](#2-predicates)
    - [3. **Actions**](#3-actions)
    - [4. **Objects**](#1-objects)
    - [5. **Initial State**](#2-initial-state)
    - [6. **Goal State**](#3-goal-state)
- [How to Run](#how-to-run)
- [Assumptions and Considerations](#assumptions-and-considerations)
- [Further Improvements](#further-improvements)

---

## Introduction

This project models the **undercity intrigue** inspired by the Netflix show *Arcane*. The planning involves characters like **Jinx**, **Vi**, and **Silco**, navigating the treacherous world of Zaun. The domain captures the dynamics of **loyalty**, **deception**, and **exposing traitors**. Using epistemic planning techniques, agents reason about their own beliefs and the beliefs of others to achieve their objectives.

The domain is designed to showcase the power of epistemic reasoning in planning, allowing agents to interact based on not only the state of the world but also their beliefs about each other.

---

## Problem Statement

The objective is for the agents **Jinx** and **Vi** to uncover the traitor **Silco** through a series of actions that involve sneaking between locations, whispering loyalty to each other, and ultimately exposing the traitor. Each agent has its own beliefs about loyalty and traitors, which evolve as actions are performed.

The intrigue arises from the **false beliefs** held by some agents, making the challenge not only about achieving a state but also about ensuring that beliefs align with reality.

---

## Domain Structure

The **undercity intrigue domain** models the interactions between agents, their movements, and their ability to influence each other's beliefs.

### Features:

- **Agents**: Represent main characters from *Arcane* (Jinx, Vi, Silco). Each agent has unique beliefs about loyalty and betrayal.
- **Locations**: Key areas in the undercity such as `The Last Drop`, `Piltover Gates`, and `Black Market` are modeled as navigable points.
- **Epistemic Reasoning**: Captures the ability of agents to reason about their own and others' beliefs.
- **Actions**: Include sneaking between locations, whispering loyalty, and exposing traitors.

The domain uses **epistemic predicates** to track both the actual world state and the agents' beliefs about the world.

---

## Instance Structure

The **undercity intrigue problem** defines the specific scenario in which agents navigate locations, reason about each other's beliefs, and uncover the traitor.

### Key Components:

- **Agents**: Jinx, Vi, and Silco, each with distinct initial beliefs.
- **Locations**: The undercity is modeled as interconnected locations (`The Last Drop`, `Factory Woods`, etc.).
- **Beliefs**: The initial state includes false beliefs, such as Jinx and Vi mistakenly believing that Silco is loyal.
- **Goal**: Jinx and Vi must come to believe that Silco is the traitor.

---

## Code Explanation

### Problem File: `problem.pdkbddl`

#### 1. **Types**

```lisp
(:types
    location
)
```

Defines the type `location`, representing navigable points in the undercity.

#### 2. **Predicates**

```lisp
(:predicates
    (is-traitor ?agent) ; Indicates if an agent is a traitor
    {AK}(diff ?a1 ?a2 - agent) ; Ensures two agents are distinct
    {AK}(in ?agent - agent ?location - location) ; Tracks the location of an agent
    {AK}(connected ?location1 ?location2 - location) ; Indicates connectivity between locations
)
```

These predicates describe the state of the world and agents' beliefs.

#### 3. **Actions**

- **sneak**: Allows agents to move stealthily between connected locations.
- **whisper-loyalty**: Enables agents to communicate their loyalty to others, updating their beliefs.
- **expose-traitor**: Lets agents reveal the traitor if they are sure of their own and another agent's loyalty.


#### 4. **Objects**

```lisp
(:objects
    the_last_drop the_lanes piltover_gates factory_woods black_market - location
)
```

Defines the locations in the undercity.

#### 5. **Initial State**

The initial state includes:
- **Agent Locations**: Jinx at `The Last Drop`, Vi at `Factory Woods`, and Silco at `Black Market`.
- **Beliefs**: False beliefs, such as Jinx and Vi thinking Silco is loyal.
- **Traitor Identification**: Silco is the traitor, which Jinx and Vi must uncover.

#### 6. **Goal State**

```lisp
(:goal
    [jinx](is-traitor silco)
    [vi](is-traitor silco)
)
```

The goal is for Jinx and Vi to believe Silco is the traitor.

---

## How to Run

1. Save the problem file (`problem.pdkbddl`) in the same directory.
2. Use an epistemic planner to execute the problem, such as `rpmep`.
   ```bash
   rpmep problem.pdkbddl
   ```
3. Verify that the output aligns with the goal state, showing how agents reasoned and acted to expose Silco as the traitor.

---

## Assumptions and Considerations

- **Belief Updates**: Assumes agents can only update beliefs if the necessary preconditions are met.
- **Action Constraints**: Actions like `whisper-loyalty` require agents to be in the same location.
- **Traitor Designation**: Silco is explicitly defined as the traitor in the initial state.
- **Epistemic Planner**: Requires a planner capable of handling epistemic reasoning.

---

## Further Improvements

- **Dynamic Belief Updates**: Introduce actions to allow agents to dynamically question and update beliefs based on indirect evidence.
- **Additional Characters**: Extend the domain to include more characters from *Arcane* with their own unique beliefs and goals.
- **Complex Goals**: Add more intricate objectives, such as convincing a third agent of someone's loyalty or betrayal.
- **Uncertainty**: Model uncertainty in beliefs to add realism, requiring agents to act on probabilities.