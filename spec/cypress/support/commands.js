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

// Open first Project
Cypress.Commands.add("open_project", () => {
  cy.get('[data-cy=project_list_items]').first().click()
  cy.wait(500)
  cy.get('#facility_sidebar').contains('Facility Manager')
})

// Open first Facility of a project
Cypress.Commands.add("open_facility", () => {
  cy.open_project()
  cy.get('[data-cy=facilities]').first().click()
  cy.wait(50)
  cy.contains('Facility Summary')
})
