# Project State

## Current Position
- **Active Milestone**: Milestone 2 (Items Database UI)
- **Active Branch**: `feat/search-and-filter-bar`
- **Active Phase**: Phase 2.3 (Search Input & Secondary Filters)
- **Status**: Navigation Shell & Category Bar completed. Target platforms expanded to include Android & Windows 10/11 Desktop.

## Decisions Log
- Target Platforms: Android Emulator (AVD) + Windows Desktop (Win 10/11)
- UI Language: 100% pt-BR (Português Brasil)
- State Management: Riverpod 2.x
- Development Workflow: Micro-incremental (Component by Component) with explicit user approval before any git commit.
- Layout Strategy: Responsive Design (Dynamic columns for mobile vs wide desktop screens).

## Completed Components / Gates
- [x] Gate 1: Project Setup & Dark Theme Baseline
- [x] Gate 2.1: Top Header Component (`CorepunkHeaderWidget`)
- [x] Gate 2.2: Category Selector Bar (`CategorySelectorWidget` in pt-BR)
- [x] Gate 2.7 (Early): Bottom Navigation Bar (`MainNavigationPage` + `IndexedStack`)

## Pending Verification / Gates
- Gate 2.3: User visual approval of Search Bar & Secondary Filters (Quality & Tier).
