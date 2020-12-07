describe('Kanban Issues View', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openKanban()
  })

  it('Open kanban issues in a facility', function() {
    cy.get('[data-cy=facility_tabs]').within(() => {
      cy.contains('Kanban Issues').should('be.visible').click()
    })
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=kanban_col_title]').contains('Test Issue Stage').should('be.visible')
    })
    cy.logout()
  })
})
