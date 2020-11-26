describe('Tasks Page', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.tasks_list()
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

  it('Close Task form', function() {
    cy.get('[data-cy=new_task]').click()
    cy.contains('Task Name:')
    cy.get('[data-cy=task_close_btn]').click()
    cy.contains('Task Name:').should('not.exist')
    cy.logout()
  })

  // it('Create new task in a Facility', function() {
  //   cy.get('[data-cy=new_task]').click()
  //   cy.contains('Task Name:')
  //   cy.get('[data-cy=new_task_name]').type('New test task').should('have.value', 'New test task')
  //   cy.get('[data-cy=new_task_description]').type('New test task description').should('have.value', 'New test task description')
  //   cy.get('[data-cy=new_task_type]').select('Test Task Type(milestone)').should('have.value', 'Test Task Type(milestone)')
  //   cy.get('[data-cy=new_task_stage]').select('').should('have.value', '')
  //   cy.get('[data-cy=new_task_start_date]').select('').should('have.value', '')
  //   cy.get('[data-cy=new_task_due_date]').select('').should('have.value', '')
  //   cy.get('[data-cy=new_task_user]').select('').should('have.value', '')
  //   cy.wait(1000)

  //   cy.logout()
  // })
})
