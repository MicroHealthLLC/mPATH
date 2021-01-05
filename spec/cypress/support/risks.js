// All Risks related commands

// Open Risks List of a facility
Cypress.Commands.add("risksList", () => {
  cy.openFacility()
  cy.get('[data-cy=facility_tabs]').contains('Risks').click()
})

// Open Kanban Risks
Cypress.Commands.add("openKanbanRisk", () => {
  cy.openKanban()
  cy.get('[data-cy=facility_tabs]').within(() => {
    cy.contains('Risks').should('be.visible').click()
  })
  cy.facilityUnderGroup()
})
