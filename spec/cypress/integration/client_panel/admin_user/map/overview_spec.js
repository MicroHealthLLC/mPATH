describe('Map Page', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openMap()
  })

  it('Open Map overview to display the summary of a Project', function() {
    cy.get('[data-cy=map_view]').within(() => {
      cy.facilityRollup()
    })
    cy.logout()
  })
})
