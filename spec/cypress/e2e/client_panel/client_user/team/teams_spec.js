describe('Teams List', function() {
  before(() => {
    cy.cleanData()
    cy.appScenario('basic')

  })
  beforeEach(() => {
    cy.login('client@test.com', 'T3$tClient')
    cy.openTeam()
  })
  
  after(() => {
    // cy.clearCookies()
  })
  it('Display list of team of a project', function() {
    cy.get('[data-cy=members_view]').within(() => {
      cy.contains('Team').should('be.visible')
      cy.get('[data-cy=team_total]').contains('Team Total: 2').should('be.visible')
      cy.contains('admin@test.com').should('be.visible')
      cy.contains('client@test.com').should('be.visible')
    })
    // cy.logout()
  })

  it('Search team member by typing in search input field', function() {
    cy.get('#taskList1').within(() => {
      cy.contains('client@test.com').should('be.visible')
      cy.contains('admin@test.com').should('be.visible')
    })
    cy.get('[data-cy=search_team_member]').clear().type('Member is not in the list').should('have.value', 'Member is not in the list')
    cy.get('[data-cy=user_data]').should('not.visible')

    cy.get('[data-cy=search_team_member]').clear().type('Test1 Admin').should('have.value', 'Test1 Admin')
    cy.get('[data-cy=user_data]').within(() => {
      cy.contains('Test1 Admin').should('be.visible')
      cy.contains('Test2 Client').should('not.visible')
    })

    cy.get('[data-cy=search_team_member]').clear().type('Test2 Client').should('have.value', 'Test2 Client')
    cy.get('[data-cy=user_data]').within(() => {
      cy.contains('Test2 Client').should('be.visible')
      cy.contains('Test1 Admin').should('not.visible')
    })

    cy.get('[data-cy=search_team_member]').clear()
    cy.get('[data-cy=user_data]').within(() => {
      cy.contains('Test2 Client').should('be.visible')
      cy.contains('Test1 Admin').should('be.visible')
    })
    cy.get('[data-cy=user_data]').its('length').should('be.eq', 2)
    // cy.logout()
  })

  it('Sort Team according to Name', function() {
    cy.get('.thead > :nth-child(2)').contains('Name').click()
    cy.get('tbody > :nth-child(1) > :nth-child(2)').first().contains('Test1').should('be.visible')
    cy.get('.thead > :nth-child(2)').contains('Name').click()
    cy.get('tbody > :nth-child(1) > :nth-child(2)').first().contains('Test2').should('be.visible')
    cy.get('.thead > :nth-child(2)').contains('Name').click()
    cy.get('tbody > :nth-child(1) > :nth-child(2)').first().contains('Test1').should('be.visible')
    // cy.logout()
  })

  it('Sort Team according to Position', function() {
    cy.get('.thead > :nth-child(3)').contains('Position').click()
    cy.get('tbody > :nth-child(1) > :nth-child(3)').first().contains('Manager').should('be.visible')
    cy.get('.thead > :nth-child(3)').contains('Position').click()
    cy.get('tbody > :nth-child(1) > :nth-child(3)').first().contains('Mr.').should('be.visible')
    cy.get('.thead > :nth-child(3)').contains('Position').click()
    cy.get('tbody > :nth-child(1) > :nth-child(3)').first().contains('Manager').should('be.visible')
    // cy.logout()
  })

  it('Sort Team according to Organization', function() {
    cy.get('.thead > :nth-child(4)').contains('Organization').click()
    cy.get('tbody > :nth-child(1) > :nth-child(4)').first().contains('Test Organization').should('be.visible')
    // cy.logout()
  })

  it('Sort Team according to Phone Number', function() {
    cy.get('.thead > :nth-child(5)').contains('Phone Number').click()
    cy.get('tbody > :nth-child(1) > :nth-child(5)').first().contains('+447400123440').should('be.visible')
    cy.get('.thead > :nth-child(5)').contains('Phone Number').click()
    cy.get('tbody > :nth-child(1) > :nth-child(5)').first().contains('+447400123450').should('be.visible')
    cy.get('.thead > :nth-child(5)').contains('Phone Number').click()
    cy.get('tbody > :nth-child(1) > :nth-child(5)').first().contains('+447400123440').should('be.visible')
    // cy.logout()
  })

  it('Sort Team according to Email', function() {
    cy.get('.thead > :nth-child(6)').contains('Email').click()
    cy.get('tbody > :nth-child(1) > :nth-child(6)').first().contains('admin@test.com').should('be.visible')
    cy.get('.thead > :nth-child(6)').contains('Email').click()
    cy.get('tbody > :nth-child(1) > :nth-child(6)').first().contains('client@test.com').should('be.visible')
    cy.get('.thead > :nth-child(6)').contains('Email').click()
    cy.get('tbody > :nth-child(1) > :nth-child(6)').first().contains('admin@test.com').should('be.visible')
    // cy.logout()
  })
})

describe('Client do not have permission of members view', function() {
  beforeEach(() => {
    cy.cleanData()
    cy.appScenario('basic')
    cy.appScenario('remove_members_view_permission')
    cy.login('client@test.com', 'T3$tClient')
  })

  it('Team tab not display in tab panel', function() {
    cy.openProject()
    cy.get('[data-cy=team_tab]').should('not.exist')
    // cy.logout()
  })
})

