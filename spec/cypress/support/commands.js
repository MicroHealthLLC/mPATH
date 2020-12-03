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
Cypress.Commands.add("openProject", () => {
  cy.get('[data-cy=project_list_items]').first().click()
  cy.get('#facility_view', { timeout: 60000 }).should('be.visible')
  cy.get('[data-cy=facility_list]', { timeout: 60000 }).should('be.visible')
  cy.get('#facility_view').within(() => {
    cy.get('[data-cy=facility_list]').contains('Facility Manager')
  })
})

// Open first Facility of a project
Cypress.Commands.add("openFacility", () => {
  cy.openProject()
  cy.get('[data-cy=facility_groups]').first().click()
  cy.get('[data-cy=facilities]').first().click()
  cy.contains('Facility Summary')
})
