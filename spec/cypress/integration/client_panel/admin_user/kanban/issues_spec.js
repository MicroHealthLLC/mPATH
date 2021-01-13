describe('Kanban Issues View', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openKanbanIssue()
  })

  it('Open kanban issues in a facility', function() {
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=kanban_col_title]').contains('Test Issue Stage').should('be.visible')
    })
    cy.logout()
  })

  it('Open and close Kanban Issue new form', function() {
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=kanban_col]').first().within(() => {
        cy.get('[data-cy=kanban_add_btn]').should('be.visible').click()
      })
    })
    cy.get('[data-cy=issue_save_btn]').should('be.disabled')
    cy.get('[data-cy=issue_close_btn]').click({force: true})
    cy.logout()
  })

  it('Update on watch state of a issue', function() {
    cy.get('[data-cy=kanban_col]').first().within(() => {
      cy.get('[data-cy=kanban_draggable]').within(() => {
        cy.get('[data-cy=issues]').first().within(() => {
          cy.get('[data-cy=on_watch_icon]').should('be.visible')
        })
        cy.get('[data-cy=issues]').first().click()
      })
    })
    cy.get('[data-cy=issue_on_watch]').click({force: true})
    cy.get('[data-cy=issue_save_btn]').click({force: true})
    cy.get('[data-cy=kanban_draggable]').within(() => {
      cy.get('[data-cy=issues]').first().within(() => {
        cy.get('[data-cy=on_watch_icon]').should('not.exist')
      })
    })
    cy.logout()
  })

  it('Drag an issue from first stage and drop it to next stage', function() {
    cy.get('[data-cy=kanban_col]').first().within(() => {
      cy.get('[data-cy=issues]').first().as('origin')
    })

    cy.get('[data-cy=kanban_col]').last().within(() => {
      cy.get('[data-cy=issues]').as('destination')
    })

    cy.get('@origin').drag('@destination', {force: true})

    cy.get('[data-cy=kanban_col]').first().within(() => {
      cy.get('[data-cy=issues]').should('not.exist')
    })

    cy.get('[data-cy=kanban_col]').last().within(() => {
      cy.get('[data-cy=issues]').its('length').should('be.eq', 4)
    })
    cy.logout()
  })

  it('Search issue by typing title', function() {
    // cy.get('[data-cy=kanban_search]').should('be.visible').first().click({force: true})
    // cy.get('[data-cy=search_issue_total]').contains('Total: 2').should('be.visible')

    cy.get('[data-cy=search_issues]').clear().type('Issue is not in the list').should('have.value', 'Issue is not in the list')
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=issues]').should('not.exist')
    })
    // cy.get('[data-cy=search_issue_total]').contains('Total: 0').should('be.visible')

    cy.get('[data-cy=search_issues]').clear().type('Test Issue').should('have.value', 'Test Issue')
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
    })
    // cy.get('[data-cy=search_issue_total]').contains('Total: 1').should('be.visible')

    cy.get('[data-cy=search_issues]').clear()
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=issues]').its('length').should('be.eq', 4)
    })
    // cy.get('[data-cy=search_issue_total]').contains('Total: 2').should('be.visible')
    cy.logout()
  })

  // it('Select issue status from list to display related issues', function() {
  //   cy.get('[data-cy=kanban_search]').should('be.visible').first().click({force: true})
  //   cy.get('[data-cy=search_issue_total]').contains('Total: 2').should('be.visible')

  //   cy.get('[data-cy=issue_status_list]').as('list')
  //   cy.get('@list').click()
  //   cy.get('@list').within(() => {
  //     cy.contains('complete').click()
  //   })
  //   cy.get('[data-cy=search_issue_total]').contains('Total: 0').should('be.visible')
  //   cy.get('[data-cy=kanban]').within(() => {
  //     cy.get('[data-cy=issues]').should('not.exist')
  //   })
  //   cy.get('@list').within(() => {
  //     cy.contains('all').click()
  //   })
  //   cy.get('[data-cy=search_issue_total]').contains('Total: 2').should('be.visible')
  //   cy.get('[data-cy=kanban]').within(() => {
  //     cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
  //   })
  //   cy.logout()
  // })

  describe('Kanban Issues Actions', function() {
    beforeEach(() => {
      cy.get('[data-cy=kanban_draggable]').within(() => {
        cy.get('[data-cy=issues]').first().click()
      })
    })

    it('Delete the issue from kanban', function() {
      cy.get('[data-cy=issue_delete_btn]').click({force: true})
      cy.get('[data-cy=kanban_col]').first().within(() => {
        cy.get('[data-cy=kanban_draggable]').within(() => {
          cy.get('[data-cy=issues]').should('not.exist')
        })
      })
      cy.logout()
    })

    it('Update issue from kanban', function() {
      cy.get('[data-cy=issue_title]').clear({force: true}).type('Updated new test issue').should('have.value', 'Updated new test issue')
      cy.get('[data-cy=issue_save_btn]').click({force: true})
      cy.get('[data-cy=kanban_draggable]').within(() => {
        cy.get('[data-cy=issues]').first().contains('Updated new test issue').should('be.visible')
      })
      cy.logout()
    })
  })
})
