---
name: collaborative-tdd-typescript
description: Use when implementing any feature or bugfix in TypeScript. Starts with collaborative test design, then follows strict TDD. Uses Vitest/Jest patterns, parametrization, and dependency injection.
---

# Collaborative TDD for TypeScript

## Overview

Two-phase TDD for TypeScript projects:
1. **Design Phase**: Collaboratively define test scenarios
2. **Build Phase**: Strict red-green-refactor with Vitest/Jest

---

## Phase 1: Test Design (Collaborative)

### Step 1.1: Gather Requirements

Ask the user:
- What functionality needs to be built?
- What are the inputs and expected outputs?
- What are edge cases and error conditions?
- What dependencies exist?
- What are the acceptance criteria?

### Step 1.2: Design Test Architecture

#### Naming Convention
```typescript
describe('UserService', () => {
  describe('createUser', () => {
    test('given valid data when creating user then returns user with id')
    test('given duplicate email when creating user then throws DuplicateEmailError')
    test('given missing required fields when creating user then throws ValidationError')
  })
})
```

#### Parametrization with test.each()
```typescript
describe('validateEmail', () => {
  test.each([
    { input: '', expectedError: 'Email is required' },
    { input: 'plainstring', expectedError: 'Invalid email format' },
    { input: 'missing@domain', expectedError: 'Invalid email format' },
    { input: '@nodomain.com', expectedError: 'Invalid email format' },
    { input: 'valid@example.com', expectedError: null },
    { input: 'user+tag@example.org', expectedError: null },
  ])('given "$input" when validating then $expectedError', ({ input, expectedError }) => {
    const result = validateEmail(input)
    if (expectedError) {
      expect(result).toEqual({ ok: false, error: expectedError })
    } else {
      expect(result).toEqual({ ok: true })
    }
  })
})
```

#### Parametrization with test.concurrent for independent tests
```typescript
describe('formatCurrency', () => {
  test.concurrent.each([
    { amount: 0, currency: 'USD', expected: '$0.00' },
    { amount: 1234.5, currency: 'USD', expected: '$1,234.50' },
    { amount: 1234.5, currency: 'EUR', expected: '€1,234.50' },
    { amount: -50, currency: 'USD', expected: '-$50.00' },
  ])('formats $amount $currency as $expected', async ({ amount, currency, expected }) => {
    expect(formatCurrency(amount, currency)).toBe(expected)
  })
})
```

#### Dependency Injection
```typescript
// Type definitions for dependencies
interface HttpClient {
  get<T>(url: string): Promise<T>
  post<T>(url: string, body: unknown): Promise<T>
}

interface Logger {
  info(message: string, meta?: Record<string, unknown>): void
  error(message: string, meta?: Record<string, unknown>): void
}

// Service with injected dependencies
type UserServiceDeps = {
  http: HttpClient
  logger: Logger
  baseUrl: string
}

function createUserServices({ http, logger, baseUrl }: UserServiceDeps) {
  return {
    async getUser(id: string) {
      logger.info('Fetching user', { id })
      return http.get<User>(`${baseUrl}/users/${id}`)
    },

    async createUser(data: CreateUserInput) {
      logger.info('Creating user', { email: data.email })
      return http.post<User>(`${baseUrl}/users`, data)
    },
  }
}

// Test with mock dependencies
describe('UserService', () => {
  const mockHttp: HttpClient = {
    get: vi.fn(),
    post: vi.fn(),
  }
  const mockLogger: Logger = {
    info: vi.fn(),
    error: vi.fn(),
  }

  const service = createUserServices({
    http: mockHttp,
    logger: mockLogger,
    baseUrl: 'https://api.example.com',
  })

  beforeEach(() => {
    vi.clearAllMocks()
  })

  test('given valid id when getUser then calls correct endpoint', async () => {
    vi.mocked(mockHttp.get).mockResolvedValueOnce({ id: '1', name: 'Test' })

    await service.getUser('1')

    expect(mockHttp.get).toHaveBeenCalledWith('https://api.example.com/users/1')
    expect(mockLogger.info).toHaveBeenCalledWith('Fetching user', { id: '1' })
  })
})
```

#### Factory Functions over Classes
```typescript
// Prefer factory functions for easier testing
type RepositoryDeps = {
  db: Database
  tableName: string
}

function createRepository<T>({ db, tableName }: RepositoryDeps) {
  return {
    async findById(id: string): Promise<T | null> {
      return db.query<T>(`SELECT * FROM ${tableName} WHERE id = $1`, [id])
    },

    async save(entity: T): Promise<T> {
      return db.insert(tableName, entity)
    },
  }
}

// Test
const mockDb = {
  query: vi.fn(),
  insert: vi.fn(),
}

const repo = createRepository<User>({ db: mockDb, tableName: 'users' })
```

### Step 1.3: Present Test Plan

Before implementing, show:
1. Test file structure
2. List of test scenarios (parametrized where applicable)
3. Dependencies and injection strategy
4. Edge cases covered

Get approval before Phase 2.

---

## Phase 2: Build (Strict TDD)

### The Iron Law
```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

### RED - Write Failing Test
```typescript
test('given empty email when validating then returns error', () => {
  const result = validateEmail('')
  expect(result).toEqual({ ok: false, error: 'Email is required' })
})
```

### Verify RED
```bash
npm test -- --run path/to/test.spec.ts
```

Confirm:
- Test fails (not TypeScript errors)
- Failure message matches expectation
- Fails because feature is missing

### GREEN - Minimal Code
```typescript
function validateEmail(email: string): ValidationResult {
  if (!email) {
    return { ok: false, error: 'Email is required' }
  }
  return { ok: true }
}
```

### Verify GREEN
```bash
npm test -- --run
```

All tests pass, no warnings.

### REFACTOR & Repeat

---

## Vitest/Jest Patterns

### Mocking
```typescript
// Module mock
vi.mock('./api', () => ({
  fetchUser: vi.fn(),
}))

// Partial mock
vi.mock('./config', () => ({
  config: {
    apiUrl: 'https://test.example.com',
  },
}))

// Spy on method
const consoleSpy = vi.spyOn(console, 'log').mockImplementation(() => {})
```

### Fixtures
```typescript
// test/fixtures/users.ts
export const validUser = {
  id: '1',
  email: 'test@example.com',
  name: 'Test User',
} as const

export const invalidUser = {
  id: '',
  email: 'invalid',
  name: '',
} as const

// Usage
import { validUser, invalidUser } from './fixtures/users'

test('given valid user when saving then persists', async () => {
  await saveUser(validUser)
})
```

### Type-Safe Mocks
```typescript
import { expectTypeOf } from 'vitest'

test('return type is correct', () => {
  const result = validateEmail('test@example.com')
  expectTypeOf(result).toMatchTypeOf<ValidationResult>()
})
```

---

## Test File Structure

```
src/
  features/
    user/
      userService.ts
      userService.test.ts
      fixtures/
        users.ts
  shared/
    validation/
      validateEmail.ts
      validateEmail.test.ts
```

---

## Anti-Patterns

| Anti-Pattern | Instead |
|--------------|---------|
| `any` in tests | Define proper types |
| Testing private methods | Test public API only |
| Shared mutable state | Fresh instances per test |
| Real timers/network | Use vi.useFakeTimers(), mocks |
| Giant describe blocks | Split into focused groups |

---

## Verification Checklist

- [ ] Test design approved by user
- [ ] Each test watched failing first
- [ ] Parametrization used for similar cases
- [ ] Dependencies injected, not global
- [ ] All tests pass
- [ ] TypeScript strict mode passes
- [ ] No console warnings/errors
