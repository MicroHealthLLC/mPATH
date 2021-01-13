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
    cy.openProject()
    cy.contains('4 Facilities').should('be.visible')
    cy.contains('Project Type: Test Project Type').should('be.visible')
    cy.contains('Facility Project Status').should('be.visible')
    cy.logout()
  })

  it('Open a facility of a project', function() {
    cy.openFacility()
    cy.get('[data-cy=facility_tabs]').contains('Overview').should('be.visible').click()
    cy.contains('Facility Group:').should('be.visible')
    cy.contains('Project Completion Date:').should('be.visible')
    cy.contains('Project Status:').should('be.visible')
    cy.logout()
  })
})
