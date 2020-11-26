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

  it('Create new task in a Facility', function() {

    const start_date = Cypress.moment().add(1, 'day').format('DD MMM YYYY')
    const due_date = Cypress.moment().add(7, 'day').format('DD MMM YYYY')

    cy.get('[data-cy=new_task]').click()
    cy.contains('Task Name:')
    cy.get('[data-cy=new_task_name]').type('New test task').should('have.value', 'New test task')
    cy.get('[data-cy=new_task_description]').type('New test task description').should('have.value', 'New test task description')
    cy.get('[data-cy=new_task_type]').click().type('{enter}')
    cy.get('[data-cy=new_task_stage]').click().type('{enter}')

    cy.get('[data-cy=new_task_start_date]').type(`${start_date}{enter}`)
    cy.get('[data-cy=new_task_due_date]').type(`${due_date}{enter}`)

    cy.get('[data-cy=new_task_user]').click().type('{enter}')
    cy.get('[data-cy=task_save_btn]').should('not.be.disabled')
    cy.get('[data-cy=task_save_btn]').click()

    cy.get('[data-cy=task_list]').contains('New test task')
    cy.logout()
  })
})
