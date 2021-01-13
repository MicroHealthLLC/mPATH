describe('Kanban Tasks View', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openKanbanTask()
  })

  it('Open kanban tasks in a facility', function() {
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=kanban_col]').first().within(() => {
        cy.get('[data-cy=kanban_col_title]').contains('Test Task Stage').should('be.visible')
      })
    })
    cy.logout()
  })

  it('Open and close Kanban task new form', function() {
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=kanban_col]').first().within(() => {
        cy.get('[data-cy=kanban_add_btn]').should('be.visible').click()
      })
    })
    cy.get('[data-cy=task_save_btn]').should('be.disabled')
    cy.get('[data-cy=task_close_btn]').click({force: true})
    cy.logout()
  })

  it('Update on watch state of a task', function() {
    cy.get('[data-cy=kanban_col]').first().within(() => {
      cy.get('[data-cy=kanban_draggable]').within(() => {
        cy.get('[data-cy=tasks]').first().within(() => {
          cy.get('[data-cy=on_watch_icon]').should('be.visible')
        })
        cy.get('[data-cy=tasks]').first().click()
      })
    })
    cy.get('[data-cy=task_on_watch]').click({force: true})
    cy.get('[data-cy=task_save_btn]').click({force: true})
    cy.get('[data-cy=kanban_col]').first().within(() => {
      cy.get('[data-cy=kanban_draggable]').within(() => {
        cy.get('[data-cy=tasks]').first().within(() => {
          cy.get('[data-cy=on_watch_icon]').should('not.exist')
        })
      })
    })
    cy.logout()
  })

  it('Drag a task from first stage and drop it to next stage', function() {
    cy.get('[data-cy=kanban_col]').first().within(() => {
      cy.get('[data-cy=tasks]').first().as('origin')
    })

    cy.get('[data-cy=kanban_col]').last().within(() => {
      cy.get('[data-cy=tasks]').as('destination')
    })

    cy.get('@origin').drag('@destination', {force: true})

    cy.get('[data-cy=kanban_col]').first().within(() => {
      cy.get('[data-cy=tasks]').should('not.exist')
    })

    cy.get('[data-cy=kanban_col]').last().within(() => {
      cy.get('[data-cy=tasks]').its('length').should('be.eq', 4)
    })
    cy.logout()
  })

  it('Search task by typing title', function() {
    // cy.get('[data-cy=kanban_search]').should('be.visible').first().click({force: true})
    // cy.get('[data-cy=search_task_total]').contains('Total: 2').should('be.visible')

    cy.get('[data-cy=search_tasks]').clear().type('task is not in the list').should('have.value', 'task is not in the list')
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=tasks]').should('not.exist')
    })
    // cy.get('[data-cy=search_task_total]').contains('Total: 0').should('be.visible')

    cy.get('[data-cy=search_tasks]').clear().type('Test task').should('have.value', 'Test task')
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=tasks]').its('length').should('be.eq', 2)
    })
    // cy.get('[data-cy=search_task_total]').contains('Total: 1').should('be.visible')

    cy.get('[data-cy=search_tasks]').clear()
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=tasks]').its('length').should('be.eq', 4)
    })
    // cy.get('[data-cy=search_task_total]').contains('Total: 2').should('be.visible')
    cy.logout()
  })

  // it('Select task status from list to display related tasks', function() {
  //   cy.get('[data-cy=kanban_search]').should('be.visible').first().click({force: true})
  //   cy.get('[data-cy=search_task_total]').contains('Total: 2').should('be.visible')

  //   cy.get('[data-cy=task_status_list]').as('list')
  //   cy.get('@list').click()
  //   cy.get('@list').within(() => {
  //     cy.contains('complete').click()
  //   })
  //   cy.get('[data-cy=search_task_total]').contains('Total: 0').should('be.visible')
  //   cy.get('[data-cy=kanban]').within(() => {
  //     cy.get('[data-cy=tasks]').should('not.exist')
  //   })
  //   cy.get('@list').within(() => {
  //     cy.contains('all').click()
  //   })
  //   cy.get('[data-cy=search_task_total]').contains('Total: 2').should('be.visible')
  //   cy.get('[data-cy=kanban]').within(() => {
  //     cy.get('[data-cy=tasks]').its('length').should('be.eq', 2)
  //   })
  //   cy.logout()
  // })

  describe('Kanban Tasks Actions', function() {
    beforeEach(() => {
      cy.get('[data-cy=kanban_col]').first().within(() => {
        cy.get('[data-cy=kanban_draggable]').within(() => {
          cy.get('[data-cy=tasks]').first().click()
        })
      })
    })

    it('Delete the task from kanban', function() {
      cy.get('[data-cy=task_delete_btn]').click({force: true})
      cy.get('[data-cy=kanban_col]').first().within(() => {
        cy.get('[data-cy=kanban_draggable]').within(() => {
          cy.get('[data-cy=tasks]').should('not.exist')
        })
      })
      cy.logout()
    })

    it('Update task from kanban', function() {
      cy.get('[data-cy=task_name]').clear({force: true}).type('Updated new test task').should('have.value', 'Updated new test task')
      cy.get('[data-cy=task_save_btn]').click({force: true})
      cy.get('[data-cy=kanban_col]').first().within(() => {
        cy.get('[data-cy=kanban_draggable]').within(() => {
          cy.get('[data-cy=tasks]').first().contains('Updated new test task').should('be.visible')
        })
      })
      cy.logout()
    })
  })
})
