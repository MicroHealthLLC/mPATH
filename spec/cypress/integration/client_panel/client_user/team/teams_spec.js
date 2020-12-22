describe('Teams List', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('client@test.com', 'T3$tClient')
    cy.openTeam()
  })

  it('Display list of team of a project', function() {
    cy.get('[data-cy=members_view]').within(() => {
      cy.contains('Team').should('be.visible')
      cy.get('[data-cy=team_total]').contains('Team Total: 2').should('be.visible')
      cy.contains('admin@test.com').should('be.visible')
      cy.contains('client@test.com').should('be.visible')
    })
    cy.logout()
  })

  it('Search team member by typing in search input field', function() {
    cy.get('[data-cy=team_members_list]').within(() => {
      cy.contains('client@test.com').should('be.visible')
      cy.contains('admin@test.com').should('be.visible')
    })
    cy.get('[data-cy=search_team_member]').clear().type('Member is not in the list').should('have.value', 'Member is not in the list')
    cy.get('[data-cy=team_members_list]').within(() => {
      cy.contains('No Data').should('be.visible')
    })
    cy.get('[data-cy=search_team_member]').clear().type('admin@test.com').should('have.value', 'admin@test.com')
    cy.get('[data-cy=team_members_list]').within(() => {
      cy.contains('admin@test.com').should('be.visible')
      cy.contains('client@test.com').should('not.exist')
    })
    cy.get('[data-cy=search_team_member]').clear().type('client@test.com').should('have.value', 'client@test.com')
    cy.get('[data-cy=team_members_list]').within(() => {
      cy.contains('client@test.com').should('be.visible')
      cy.contains('admin@test.com').should('not.exist')
    })
    cy.get('[data-cy=search_team_member]').clear()
    cy.get('[data-cy=team_members_list]').within(() => {
      cy.contains('client@test.com').should('be.visible')
      cy.contains('admin@test.com').should('be.visible')
    })
    cy.logout()
  })
})

describe('Client do not have permission of members view', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.appScenario('remove_members_view_permission')
    cy.login('client@test.com', 'T3$tClient')
  })

  it('Team tab not display in tab panel', function() {
    cy.openProject()
    cy.get('[data-cy=team_tab]').should('not.exist')
    cy.logout()
  })
})

