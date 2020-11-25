describe('Projects List', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
  })

  it('Display list of projects', function() {
    cy.get('[data-cy=project_list_items]').first().should('contain', 'Facilities')
  })

  it('Open a particular project', function() {
    cy.get('[data-cy=project_list_items]').first().click()
    cy.get('#facility_sidebar').contains('Facility Manager')
    cy.logout()
  })
})
