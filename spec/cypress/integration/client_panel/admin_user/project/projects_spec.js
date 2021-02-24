describe('Projects List', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
  })

  it('Display list of projects', function() {
    cy.get('[data-cy=project_list_items]').should('contain', 'Projects')
    cy.get('[data-cy=project_list_items]').its('length').should('be.eq', 1)
  })

  it('Open a particular project', function() {
    cy.openProject()
    cy.get('[data-cy=facility_rollup]').within(() => {
      cy.contains('PROJECTS').should('be.visible')
      cy.contains('4').should('be.visible')
    })
    cy.logout()
  })

  it('Open a facility of a project', function() {
    cy.openFacility()
    cy.facilityRollup()
    cy.logout()
  })
})
