describe('Teams List', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
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
    cy.get('#taskList1').within(() => {
      cy.contains('client@test.com').should('be.visible')
      cy.contains('admin@test.com').should('be.visible')
    })
    cy.get('[data-cy=search_team_member]').clear().type('Member is not in the list').should('have.value', 'Member is not in the list')
    cy.get('[data-cy=user_data]').should('not.visible')

    cy.get('[data-cy=search_team_member]').clear().type('Test Admin').should('have.value', 'Test Admin')
    cy.get('[data-cy=user_data]').within(() => {
      cy.contains('Test Admin').should('be.visible')
      cy.contains('Test Client').should('not.visible')
    })

    cy.get('[data-cy=search_team_member]').clear().type('Test Client').should('have.value', 'Test Client')
    cy.get('[data-cy=user_data]').within(() => {
      cy.contains('Test Client').should('be.visible')
      cy.contains('Test Admin').should('not.visible')
    })

    cy.get('[data-cy=search_team_member]').clear()
    cy.get('[data-cy=user_data]').within(() => {
      cy.contains('Test Client').should('be.visible')
      cy.contains('Test Admin').should('be.visible')
    })
    cy.get('[data-cy=user_data]').its('length').should('be.eq', 2)
    cy.logout()
  })
})
