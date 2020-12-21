describe('Projects List', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('client@test.com', 'T3$tClient')
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
    cy.contains('Facility Group:').should('be.visible')
    cy.contains('Project Completion Date:').should('be.visible')
    cy.contains('Project Status:').should('be.visible')
    cy.logout()
  })
})

describe('No Project for client', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.appScenario('remove_client_from_project')
    cy.login('client@test.com', 'T3$tClient')
  })

  it('Display no projects', function() {
    cy.get('[data-cy=project_list_items]').should('not.exist')
    cy.get('[data-cy=not_access_projects]')
      .contains('Currently you dont have permissions to access projects')
      .should('be.visible')
    cy.logout()
  })
})

describe('Client do not have permission of facility manager view', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.appScenario('remove_facility_mmanager_permission')
    cy.login('client@test.com', 'T3$tClient')
  })

  it('Facility manager tab not display in tab panel', function() {
    cy.get('[data-cy=project_list_items]').first().click()
    cy.get('[data-cy=facility_manager_tab]').should('not.exist')
    cy.logout()
  })
})
