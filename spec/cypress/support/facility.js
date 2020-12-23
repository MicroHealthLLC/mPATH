// check facility rollup
Cypress.Commands.add("facilityRollup", () => {
  cy.get('[data-cy=facility_rollup]').within(() => {
    cy.contains('Project Type: Test Project Type').should('be.visible')
    cy.contains('Facility Project Status').should('be.visible')
    cy.contains('4 Facilities').should('be.visible')

    // In sheet view display task summary
    cy.get('[data-cy=tasks_summary]').scrollIntoView()
    cy.get('[data-cy=tasks_summary]').within(() => {
      cy.contains('6 Tasks').should('be.visible')
      cy.contains('Task Categories').should('be.visible')
      cy.contains('Test Task Type(milestone)').should('be.visible')
    })

    // In sheet view display Issues summary
    cy.get('[data-cy=issues_summary]').scrollIntoView()
    cy.get('[data-cy=issues_summary]').within(() => {
      cy.contains('6 Issues').should('be.visible')
      cy.contains('Issue Types').should('be.visible')
      cy.contains('Test Issue Type').should('be.visible')
    })

    // In sheet view display Facility group summary
    cy.get('[data-cy=facility_group_summary]').scrollIntoView()
    cy.get('[data-cy=facility_group_summary]').within(() => {
      cy.contains('Facility Groups').should('be.visible')
      cy.contains('Test Facility Group 1').should('be.visible')
      cy.contains('Test Facility Group 2').should('be.visible')
    })
  })
})
