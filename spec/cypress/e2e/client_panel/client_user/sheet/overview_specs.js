describe('Sheet Overview Page', function() {
  before(() => {
    cy.cleanData()
    cy.appScenario('basic')

  })
  beforeEach(() => {
    cy.login('client@test.com', 'T3$tClient')
    cy.openFacilitySheet()
  })
  
  after(() => {
    // cy.clearCookies()
  })
  it('Open Sheet overview to display the summary of a facility', function() {
    // cy.get('[data-cy=facility_sheets]').within(() => {
    // })

    // cy.get('[data-cy=facility_tabs]').first().contains('Overview').should('be.visible')
    cy.contains('GROUP NAME:').should('be.visible')
    cy.contains('COMPLETION DATE:').should('be.visible')
    cy.get('[data-cy=facility_sheets]').scrollIntoView()
    cy.contains('STATUS:').should('be.visible')

    cy.get('[data-cy="program_name"]').click()
    
    // In overview display task summary
    // cy.get('[data-cy=facility_tasks]').scrollIntoView()
    cy.get('[data-cy=task_summary]').within(() => {
      cy.contains('TASKS').should('be.visible')
      cy.contains('2').should('be.visible')
    })

    // In overview display Issues summary
    // cy.get('[data-cy=facility_issues]').scrollIntoView()
    cy.get('[data-cy=issue_summary]').within(() => {
      cy.contains('ISSUES').should('be.visible')
      cy.contains('2').should('be.visible')
    })

    // In overview display Issues summary
    // cy.get('[data-cy=facility_risks]').scrollIntoView()
    cy.get('[data-cy=risk_summary]').within(() => {
      cy.contains('RISKS').should('be.visible')
      cy.contains('2').should('be.visible')
    })

    // cy.logout()
  })
})
