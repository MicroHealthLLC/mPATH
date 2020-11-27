describe('Tasks Page', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.tasksList()
  })

  it('Open Task list page of a Facility', function() {
    cy.contains('My Tasks')
    cy.logout()
  })

  it('Open new Task form page', function() {
    cy.get('[data-cy=new_task]').click()
    cy.contains('Task Name:')
    cy.get('[data-cy=task_save_btn]').should('be.disabled')
    cy.logout()
  })

  it('Close Task form', function() {
    cy.get('[data-cy=new_task]').click()
    cy.contains('Task Name:')
    cy.get('[data-cy=task_close_btn]').click()
    cy.contains('Task Name:').should('not.exist')
    cy.logout()
  })

  it('Create new task in a Facility', function() {
    cy.createNewTask()
    cy.get('[data-cy=task_total]').contains('Total: 2')
    cy.get('[data-cy=task_list]').contains('New test task')
    cy.logout()
  })
})
