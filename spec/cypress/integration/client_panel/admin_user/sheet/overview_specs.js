describe('Sheet Overview Page', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openFacilitySheet()
    cy.get('[data-cy=facility_tabs]').contains('Overview').should('be.visible').click()
  })

  it('Open Sheet overview to display the summary of a facility', function() {
    cy.get('[data-cy=facility_sheets]').within(() => {
      cy.get('[data-cy=facility_tabs]').first().contains('Overview').should('be.visible')
      cy.contains('Facility Summary').should('be.visible')
      cy.contains('Facility Group:').should('be.visible')
      cy.contains('Project Completion Date:').should('be.visible')
      cy.contains('Project Status:').should('be.visible')
      cy.contains('Facility Progress:').should('be.visible')

      // In overview display task summary
      cy.get('[data-cy=facility_tasks]').scrollIntoView()
      cy.get('[data-cy=facility_tasks]').within(() => {
        cy.contains('2 Tasks').should('be.visible')
      })
      cy.get('[data-cy=task_categories]').within(() => {
        cy.contains('Task Categories').should('be.visible')
        cy.contains('Test Task Type(milestone)').should('be.visible')
      })

      // In overview display Issues summary
      cy.get('[data-cy=issue_types]').scrollIntoView()
      cy.get('[data-cy=facility_issues]').within(() => {
        cy.contains('2 Issues').should('be.visible')
      })

      cy.get('[data-cy=issue_types]').within(() => {
        cy.contains('Issue Types').should('be.visible')
        cy.contains('Test Issue Type').should('be.visible')
      })
    })
    cy.logout()
  })
})
