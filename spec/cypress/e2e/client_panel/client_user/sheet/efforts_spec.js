describe('Sheets Tasks View', function() {
  before(() => {
    cy.cleanData()
    cy.appScenario('effort/basic')
    // cy.appScenario('provide_all_privileges')

  })
  beforeEach(() => {
    cy.login('client@test.com', 'T3$tClient')
    cy.openFacilitySheet()
    cy.get('[data-cy=effort]').contains('Effort').should('be.visible').click()
  })
  
  after(() => {
    // cy.clearCookies()
  })
  it.skip('Open Sheets efforts in a facility', function() {
    cy.contains('Search Tasks').should('be.visible')
    cy.contains('Week Of Begin:').should('be.visible')
    cy.contains('Week Of End:').should('be.visible')
    cy.contains('Summary').should('be.visible')
  })

  it.skip('Add user effort sheet', function() {
    cy.get('[data-cy=add_user_select]').type('Test2 Client')
    cy.get("[data-cy=add_user_option]").contains("Test2 Client").click()
    cy.get('.effort_tab_pane').its('length').should('be.eq', 1)
    cy.get('[data-cy=add_user_btn]').click()
    cy.get('.effort_tab_pane').its('length').should('be.eq', 2)   
  })

  it.only('Add effort to effort sheet', function() {
    cy.get('[data-cy=add_user_select]').type('Test1 Admin')
    cy.get("[data-cy=add_user_option]").contains("Test1 Admin").click()
    cy.get('.effort_tab_pane').its('length').should('be.eq', 2)
    cy.get('[data-cy=add_user_btn]').click()
    cy.get('.effort_tab_pane').its('length').should('be.eq', 3)

    cy.get('[data-cy=effort_tab]').within(() => {
      cy.get('#tab-2').click()

      cy.get('[data-cy=effort_tab_pane]').eq(1).within(() => {

        cy.get("[data-cy=add_edit_effort_btn]").eq(1).click()
        cy.get("[data-cy=effort_input]").eq(0).type("10")
        cy.get("[data-cy=effort_input]").eq(2).type("20")
        cy.get("[data-cy=save_effort_btn]").click()
        // checking actual value
        cy.get("[data-cy=effort_table] > div.el-table__body-wrapper.is-scrolling-left > table > tbody > tr > td").eq(1).contains("30").should('be.visible')
        // checking task name
        cy.get("[data-cy=effort_table] > div.el-table__body-wrapper.is-scrolling-left > table > tbody > tr > td").eq(2).contains("Test Task 1").should('be.visible')
        //checking effort value in column
        cy.get("[data-cy=effort_table] div.el-table__body-wrapper.is-scrolling-left > table > tbody > tr > td").eq(3).contains("10").should('be.visible')

      })
    
    })    
  })

  it.skip('update effort to effort sheet', function() {
    cy.get('[data-cy=effort_tab]').within(() => {
      cy.get('#tab-1').click()
      cy.get("[data-cy=add_edit_effort_btn]").click()
      cy.get("[data-cy=effort_input]").eq(0).type("20")
      cy.get("[data-cy=effort_input]").eq(2).type("20")
      cy.get("[data-cy=save_effort_btn]").click()
      // checking actual value
      cy.get("[data-cy=effort_table] > div.el-table__body-wrapper.is-scrolling-left > table > tbody > tr > td").eq(1).contains("40").should('be.visible')
      // checking task name
      cy.get("[data-cy=effort_table] > div.el-table__body-wrapper.is-scrolling-left > table > tbody > tr > td").eq(2).contains("Test Task 1").should('be.visible')
      //checking effort value in column
      cy.get("[data-cy=effort_table] div.el-table__body-wrapper.is-scrolling-left > table > tbody > tr > td").eq(3).contains("20").should('be.visible')     
    })
  })

  it.skip('Search task by typing title', function() {
    cy.get('[data-cy=task_row]').its('length').should('be.eq', 2)
    cy.get('[data-cy=search_tasks]').clear().type('task is not in the list').should('have.value', 'task is not in the list')
    cy.contains('No Tasks found...').should('be.visible')

    cy.get('[data-cy=search_tasks]').clear().type('New task').should('have.value', 'New task')
    cy.get('[data-cy=task_row]').its('length').should('be.eq', 1)
    cy.get('[data-cy=search_tasks]').clear()
    cy.get('[data-cy=task_row]').its('length').should('be.eq', 2)
    // cy.logout()
  })

  it.skip('Sort Task according to Task name', function() {
    cy.get('[data-cy=task_row]').first().contains('New Task 1').should('be.visible')
    cy.get('[data-cy=tasks_table] > tr > :nth-child(1)').click()
    cy.get('[data-cy=task_row]').first().contains('Test Task 1').should('be.visible')
    cy.get('[data-cy=tasks_table] > tr > :nth-child(1)').click()
    cy.get('[data-cy=task_row]').first().contains('New Task 1').should('be.visible')
    // cy.logout()
  })

  it.skip('Sort Task according to Category', function() {
    cy.get('[data-cy=tasks_table] > tr > :nth-child(2)').click()
    cy.get('[data-cy=task_row]').first().contains('Test Task Type(milestone)').should('be.visible')
    // cy.logout()
  })

  it.skip('Sort Task according to Start Date', function() {
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

  it.skip('Sort Task according to Due Date', function() {
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

  it.skip('Sort Task according to Assigned User', function() {
    cy.reload()
    cy.get('[data-cy=responsibleUsers]').click()
    cy.get('[data-cy=task_row]').first().contains('Test1 Admin').should('be.visible')
    cy.get('[data-cy=responsibleUsers]').click()
    cy.get('[data-cy=task_row]').first().contains('Test2 Client').should('be.visible')
    cy.get('[data-cy=responsibleUsers]').click()
    cy.get('[data-cy=task_row]').first().contains('Test1 Admin').should('be.visible')
    // cy.logout()
  })

  it.skip('Sort Task according to Progress', function() {
    cy.reload()
    cy.get('[data-cy=tasks_table] > tr > :nth-child(6)').click()
    cy.get('[data-cy=task_row]').first().contains('10%').should('be.visible')
    cy.get('[data-cy=tasks_table] > tr > :nth-child(6)').click()
    cy.get('[data-cy=task_row]').first().contains('70%').should('be.visible')
    cy.get('[data-cy=tasks_table] > tr > :nth-child(6)').click()
    cy.get('[data-cy=task_row]').first().contains('10%').should('be.visible')
    // cy.logout()
  })

  it.skip('Sort Task according to Last Update', function() {
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
