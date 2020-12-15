import '@4tw/cypress-drag-drop'

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

Cypress.Commands.add("facilityUnderGroup", () => {
  cy.get('[data-cy=facility_groups]').first().click()
  cy.get('[data-cy=facilities]').first().click()
})

// Open Facility Manager of a project
Cypress.Commands.add("openFacility", () => {
  cy.openProject()
  cy.facilityUnderGroup()
  cy.contains('Facility Summary')
})

// Open Teams page of a project
Cypress.Commands.add("openTeam", () => {
  cy.openProject()
  cy.get('[data-cy=team_tab]').contains('Team').should('be.visible').click()
})

// Open Kanban view of a project
Cypress.Commands.add("openKanban", () => {
  cy.openProject()
  cy.get('[data-cy=kanban_tab]').contains('Kanban').should('be.visible').click()
})

// Open Sheet view of a project
Cypress.Commands.add("openSheet", () => {
  cy.openProject()
  cy.get('[data-cy=sheets_tab]').contains('Sheets').should('be.visible').click()
})

// Open sheet of a facility
Cypress.Commands.add("openFacilitySheet", () => {
  cy.openSheet()
  cy.facilityUnderGroup()
})

// Open On watch view of a project
Cypress.Commands.add("openOnWatch", () => {
  cy.openProject()
  cy.get('[data-cy=on_watch_tab]').contains('On Watch').should('be.visible').click()
})
