describe('Kanban Tasks View', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openKanbanTask()
  })

  it('Open kanban tasks in a facility', function() {
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=kanban_col_title]').contains('Test Task Stage').should('be.visible')
    })
    cy.logout()
  })

  it('Open and close Kanban task new form', function() {
    cy.get('[data-cy=kanban]').within(() => {
      cy.get('[data-cy=kanban_add_btn]').should('be.visible').click()
    })
    cy.get('[data-cy=task_save_btn]').should('be.disabled')
    cy.get('[data-cy=task_close_btn]').click()
    cy.logout()
  })

  it('Update on watch state of a task', function() {
    cy.get('[data-cy=kanban_draggable]').within(() => {
      cy.get('[data-cy=tasks]').first().within(() => {
        cy.get('[data-cy=on_watch_icon]').should('be.visible')
      })
      cy.get('[data-cy=tasks]').first().click()
    })
    cy.get('[data-cy=task_on_watch]').click({force: true})
    cy.get('[data-cy=task_save_btn]').click({force: true})
    cy.get('[data-cy=kanban_draggable]').within(() => {
      cy.get('[data-cy=tasks]').first().within(() => {
        cy.get('[data-cy=on_watch_icon]').should('not.exist')
      })
    })
    cy.logout()
  })

  describe('Kanban Tasks Actions', function() {
    beforeEach(() => {
      cy.get('[data-cy=kanban_draggable]').within(() => {
        cy.get('[data-cy=tasks]').first().click()
      })
    })

    it('Delete the task from kanban', function() {
      cy.get('[data-cy=task_delete_btn]').click({force: true})
      cy.get('[data-cy=kanban_draggable]').within(() => {
        cy.get('[data-cy=tasks]').should('not.exist')
      })
      cy.logout()
    })

    it('Update task from kanban', function() {
      cy.get('[data-cy=task_name]').clear({force: true}).type('Updated new test task').should('have.value', 'Updated new test task')
      cy.get('[data-cy=task_save_btn]').click({force: true})
      cy.get('[data-cy=kanban_draggable]').within(() => {
        cy.get('[data-cy=tasks]').first().contains('Updated new test task').should('be.visible')
      })
      cy.logout()
    })
  })
})
