describe('Sheets Tasks View', function() {
  before(() => {
    cy.app('clean')
    cy.appScenario('basic')
    // cy.appScenario('provide_all_privileges')
    cy.login('client@test.com', 'T3$tClient')
    cy.openFacilitySheet()
    cy.get('#customtabs > :nth-child(2)').contains('Tasks').should('be.visible').click()
  })
  beforeEach(() => {
    cy.preserveAllCookiesOnce()
  })
  
  after(() => {
    cy.clearCookies()
  })
  it('Open Sheets tasks in a facility', function() {
    cy.get('[data-cy=task_sheet_index]').within(() => {
      cy.get('[data-cy=task_total]').contains('Total: 2').should('be.visible')
      cy.get('[data-cy=tasks_table]').should('be.visible')
    })
    // cy.logout()
  })

  it('Open task from sheet task table', function() {
    cy.get('[data-cy=task_row]').first().should('be.exist').click({force: true})
    cy.get('[data-cy=task_close_btn]').should('be.exist').click({force: true})
    // cy.logout()
  })

  it('Search task by typing title', function() {
    cy.get('[data-cy=task_row]').its('length').should('be.eq', 2)
    cy.get('[data-cy=search_tasks]').clear().type('task is not in the list').should('have.value', 'task is not in the list')
    cy.contains('No Tasks found...').should('be.visible')

    cy.get('[data-cy=search_tasks]').clear().type('New task').should('have.value', 'New task')
    cy.get('[data-cy=task_row]').its('length').should('be.eq', 1)
    cy.get('[data-cy=search_tasks]').clear()
    cy.get('[data-cy=task_row]').its('length').should('be.eq', 2)
    // cy.logout()
  })

  it('Sort Task according to Task name', function() {
    cy.get('[data-cy=task_row]').first().contains('New Task 1').should('be.visible')
    cy.get('[data-cy=tasks_table] > tr > :nth-child(1)').click()
    cy.get('[data-cy=task_row]').first().contains('Test Task 1').should('be.visible')
    cy.get('[data-cy=tasks_table] > tr > :nth-child(1)').click()
    cy.get('[data-cy=task_row]').first().contains('New Task 1').should('be.visible')
    // cy.logout()
  })

  it('Sort Task according to Category', function() {
    cy.get('[data-cy=tasks_table] > tr > :nth-child(2)').click()
    cy.get('[data-cy=task_row]').first().contains('Test Task Type(milestone)').should('be.visible')
    // cy.logout()
  })

  it('Sort Task according to Start Date', function() {
    var dayjs = require('dayjs')
    const new_start_date = dayjs().add(1, 'day').format('DD MMM YYYY')
    const test_start_date = dayjs().format('DD MMM YYYY')
    cy.get('[data-cy=task_row]').first().contains(new_start_date).should('be.visible')
    cy.get('[data-cy=tasks_table] > tr > :nth-child(3)').click()
    cy.get('[data-cy=task_row]').first().contains(test_start_date).should('be.visible')
    cy.get('[data-cy=tasks_table] > tr > :nth-child(3)').click()
    cy.get('[data-cy=task_row]').first().contains(new_start_date).should('be.visible')
    // cy.logout()
  })

  it('Sort Task according to Due Date', function() {
    cy.reload()
    var dayjs = require('dayjs')
    const new_due_date = dayjs().add(6, 'day').format('DD MMM YYYY')
    const test_due_date = dayjs().add(5, 'day').format('DD MMM YYYY')
    cy.get('[data-cy=task_row]').first().contains(new_due_date).should('be.visible')
    cy.get('[data-cy=tasks_table] > tr > :nth-child(4)').click()
    cy.get('[data-cy=task_row]').first().contains(test_due_date).should('be.visible')
    cy.get('[data-cy=tasks_table] > tr > :nth-child(4)').click()
    cy.get('[data-cy=task_row]').first().contains(new_due_date).should('be.visible')
    // cy.logout()
  })

  it('Sort Task according to Assigned User', function() {
    cy.reload()
    cy.get('[data-cy=responsibleUsers]').click()
    cy.get('[data-cy=task_row]').first().contains('Test1 Admin').should('be.visible')
    cy.get('[data-cy=responsibleUsers]').click()
    cy.get('[data-cy=task_row]').first().contains('Test2 Client').should('be.visible')
    cy.get('[data-cy=responsibleUsers]').click()
    cy.get('[data-cy=task_row]').first().contains('Test1 Admin').should('be.visible')
    // cy.logout()
  })

  it('Sort Task according to Progress', function() {
    cy.reload()
    cy.get('[data-cy=tasks_table] > tr > :nth-child(6)').click()
    cy.get('[data-cy=task_row]').first().contains('10%').should('be.visible')
    cy.get('[data-cy=tasks_table] > tr > :nth-child(6)').click()
    cy.get('[data-cy=task_row]').first().contains('70%').should('be.visible')
    cy.get('[data-cy=tasks_table] > tr > :nth-child(6)').click()
    cy.get('[data-cy=task_row]').first().contains('10%').should('be.visible')
    // cy.logout()
  })

  it('Sort Task according to Last Update', function() {
    cy.get('[data-cy=tasks_table] > tr > :nth-child(8)').click()
    cy.get('[data-cy=task_row]').first().contains('No Updates').should('be.visible')
    // cy.logout()
  })

  // it('Create New Task', function() {
  //   cy.get('[data-cy=add_task]').click()
  //   cy.get('[data-cy="task_name"').clear().type('1 New task').should('have.value', '1 New task')
  //   cy.get('[data-cy="task_description"').clear().type('1 New task description').should('have.value', '1 New task description')
  //   cy.get('data-cy="task_type"').click()
  // })

})
