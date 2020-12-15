describe('On watch issue details', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openOnWatch()
  })

  it('Open On Watch issues to display watched issues', function() {
    cy.get('[data-cy=watch_view]').within(() => {
      cy.get('[data-cy=watched_issue_status]').scrollIntoView()
      cy.get('h5').contains('Watched Issues Stats').should('be.visible')
      cy.get('[data-cy=watched_issue_types]').within(() => {
        cy.get('h5').contains('Watched Issue Types').should('be.visible')
        cy.contains('Test Issue Type').should('be.visible')
      })
      cy.get('[data-cy=watched_issue_list]').within(() => {
        cy.get('h5').contains('Watched Issues').should('be.visible')
        cy.get('[data-cy=issues]').its('length').should('be.eq', 5)
      })
      cy.get('[data-cy=watched_issues_vs_total]').scrollIntoView()
      cy.get('[data-cy=watched_issues_vs_total]').within(() => {
        cy.get('h6').contains('Watched Issues vs Total').should('be.visible')
      })
      cy.get('[data-cy=assigned_issue_users]').within(() => {
        cy.get('h6').contains('Assigned Users').should('be.visible')
        cy.get('p').contains('Total Assigned Issues and Checklist Items').should('be.visible')
      })
    })
    cy.logout()
  })
})
