describe('Kanban Issues View', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('client@test.com', 'T3$tClient')
    cy.openKanbanIssue()
  })

  it('Open kanban issues in a facility', function() {
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=kanban_col_title]').contains('Test Issue Stage').should('be.visible')
    })
    cy.logout()
  })

  it('Cannot open new Issue form and edit/delete existing issue', function() {
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=kanban_add_btn]').should('not.exist')
      cy.get('[data-cy=kanban_col]').first().within(() => {
        cy.get('[data-cy=issues]').first().click()
      })
    })
    cy.get('[data-cy=issue_read_only_btn]').should('be.disabled')
    cy.get('[data-cy=issue_save_btn]').should('not.exist')
    cy.get('[data-cy=issue_delete_btn]').should('not.exist')
    cy.get('[data-cy=issue_close_btn]').click({force: true})
    cy.logout()
  })

  it('Drag an issue from first stage and drop it to next stage', function() {
    cy.get('[data-cy=kanban_col]').first().within(() => {
      cy.get('[data-cy=issues]').first().as('origin')
    })

    cy.get('[data-cy=kanban_col]').last().within(() => {
      cy.get('[data-cy=issues]').as('destination')
    })

    cy.get('@origin').drag('@destination')

    cy.get('[data-cy=kanban_col]').first().within(() => {
      cy.get('[data-cy=issues]').should('not.exist')
    })

    cy.get('[data-cy=kanban_col]').last().within(() => {
      cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
    })
    cy.logout()
  })

  it('Search issue by typing title', function() {
    cy.get('[data-cy=kanban_search]').should('be.visible').first().click({force: true})
    cy.get('[data-cy=search_issue_total]').contains('Total: 2').should('be.visible')

    cy.get('[data-cy=search_issues]').clear().type('Issue is not in the list').should('have.value', 'Issue is not in the list')
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=issues]').should('not.exist')
    })
    cy.get('[data-cy=search_issue_total]').contains('Total: 0').should('be.visible')

    cy.get('[data-cy=search_issues]').clear().type('Test Issue').should('have.value', 'Test Issue')
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=issues]').its('length').should('be.eq', 1)
    })
    cy.get('[data-cy=search_issue_total]').contains('Total: 1').should('be.visible')

    cy.get('[data-cy=search_issues]').clear()
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
    })
    cy.get('[data-cy=search_issue_total]').contains('Total: 2').should('be.visible')
    cy.logout()
  })

  it('Select issue status from list to display related issues', function() {
    cy.get('[data-cy=kanban_search]').should('be.visible').first().click({force: true})
    cy.get('[data-cy=search_issue_total]').contains('Total: 2').should('be.visible')

    cy.get('[data-cy=issue_status_list]').as('list')
    cy.get('@list').click()
    cy.get('@list').within(() => {
      cy.contains('complete').click()
    })
    cy.get('[data-cy=search_issue_total]').contains('Total: 0').should('be.visible')
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=issues]').should('not.exist')
    })
    cy.get('@list').within(() => {
      cy.contains('all').click()
    })
    cy.get('[data-cy=search_issue_total]').contains('Total: 2').should('be.visible')
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
    })
    cy.logout()
  })
})
