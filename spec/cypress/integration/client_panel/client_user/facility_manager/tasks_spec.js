describe('Tasks Page', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('client@test.com', 'T3$tClient')
    cy.tasksList()
  })

  it('Open Task list page of a Facility', function() {
    cy.get('[data-cy=task_list]').contains('My Task').should('be.visible')
    cy.logout()
  })

  it('Cannot open new task form and edit/delete existing task', function() {
    cy.get('[data-cy=new_task]').should('not.exist')
    cy.get('[data-cy=tasks]').first().click()
    cy.contains('Task Name:')
    cy.get('[data-cy=task_read_only_btn]').should('be.disabled')
    cy.get('[data-cy=task_delete_btn]').should('not.exist')
    cy.get('[data-cy=task_close_btn]').click()
    cy.logout()
  })

  it('Search task by typing title', function() {
    cy.get('[data-cy=tasks]').its('length').should('be.eq', 2)
    cy.get('[data-cy=search_tasks]').clear().type('task is not in the list').should('have.value', 'task is not in the list')
    cy.contains('No tasks found..').should('be.visible')

    cy.get('[data-cy=search_tasks]').clear().type('Test task').should('have.value', 'Test task')
    cy.get('[data-cy=tasks]').its('length').should('be.eq', 1)

    cy.get('[data-cy=search_tasks]').clear()
    cy.get('[data-cy=tasks]').its('length').should('be.eq', 2)
    cy.logout()
  })

  it('Select task status from list to display related tasks', function() {
    cy.get('[data-cy=tasks]').its('length').should('be.eq', 2)
    cy.get('[data-cy=task_status_list]').as('list')
    cy.get('@list').click()
    cy.get('@list').within(() => {
      cy.contains('complete').click()
    })
    cy.contains('No tasks found..').should('be.visible')
    cy.get('@list').within(() => {
      cy.contains('all').click()
    })
    cy.get('[data-cy=tasks]').its('length').should('be.eq', 2)
    cy.logout()
  })
})
