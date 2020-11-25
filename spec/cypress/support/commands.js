// Login command
Cypress.Commands.add("login", (email, password) => {
  cy.visit('/')
  cy.get('[data-cy=user_email]').type(email).should('have.value', email)
  cy.get('[data-cy=user_password]').type(password).should('have.value', password)
  cy.get('[data-cy=user_remember_me]').click()
  cy.get('[data-cy=submit]').click()
  cy.contains('Welcome to MicroHealth Geographical Information System')
})

// Logout Command
Cypress.Commands.add("logout", () => {
  cy.get('[data-cy=logout]').click()
  cy.contains('You need to sign in before continuing.')
})

// Ready state to run the tests
