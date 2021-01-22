describe('Admin Panel Task', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openTaskAP()
  })

  it('Click on Tasks on tabs open Task information page', function() {
    cy.get('#page_title').contains('Tasks').should('be.visible')
    cy.get('#index_table_tasks').should('be.visible')
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 6)
    cy.get('#logout').click()
  })

  it('Open and close new Task form', function() {
    cy.get('.action_item > a').contains('New Task').click()
    cy.get('#page_title').contains('New Task').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })

  it('Delete Task', function() {
    cy.get('#index_table_tasks').should('be.visible')
    cy.get('#index_table_tasks > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Task was successfully destroyed.').should('be.visible')
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 5)
    cy.get('#logout').click()
  })

  it('Delete all Task', function() {
    cy.get('.disabled').contains('Batch Actions').should('be.visible')
    cy.get('#collection_selection_toggle_all').click()
    cy.get('.dropdown_menu_button').click()
    cy.get('.batch_action').contains('Delete Selected').click()
    cy.get('.ui-dialog-buttonset > :nth-child(1)').contains('OK').click()
    cy.get('.flashes').contains('Successfully deleted 6 Tasks').should('be.visible')
    cy.get('.blank_slate').contains('There are no Tasks yet.').should('be.visible')
    cy.get('#logout').click()
  })

  it('Search Task contains name', function() {
    cy.get('#q_text').type('Test Task 1').should('have.value', 'Test Task 1')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').scrollIntoView()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Name contains Test Task 1').should('be.visible')
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 1)
    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
    cy.get('#logout').click()
  })

  it('Search Task by Task Category', function() {
    cy.get('#index_table_tasks').should('be.visible')
    cy.get('#q_task_type_id').select('Test Task Type(milestone)')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 6)
    cy.get('#q_task_type_id').select('Any')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 6)
    cy.get('#logout').click()
  })

  it('Search Task by Task Stage', function() {
    cy.get('#index_table_tasks').should('be.visible')
    cy.get('#q_task_stage_id').select('Test Task Stage')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 4)
    cy.get('#q_task_stage_id').select('New Task Stage')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#q_task_stage_id').select('Any')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 6)
    cy.get('#logout').click()
  })

  it('Search Task start date from', function() {
    const start_date = Cypress.moment().add(1, 'day').format('YYYY-MM-DD')
    cy.get('#q_start_date_gteq').type(`${start_date}{enter}`)
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 3)
    cy.get('#logout').click()
  })

  it('Search Task start date to', function() {
    const start_date = Cypress.moment().format('YYYY-MM-DD')
    cy.get('#q_start_date_lteq').type(`${start_date}{enter}`)
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 3)
    cy.get('#logout').click()
  })

  it('Search Task Estimated Completion Date from', function() {
    const completion_date = Cypress.moment().add(6, 'day').format('YYYY-MM-DD')
    cy.get('#q_due_date_gteq').type(`${completion_date}{enter}`)
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 3)
    cy.get('#logout').click()
  })

  it('Search Task Estimated Completion Date to', function() {
    const completion_date = Cypress.moment().add(5, 'day').format('YYYY-MM-DD')
    cy.get('#q_due_date_lteq').type(`${completion_date}{enter}`)
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 3)
    cy.get('#logout').click()
  })

  it('Search Task by Project', function() {
    cy.get('#index_table_tasks').should('be.visible')
    cy.get('#q_facility_project_project_id').select('Test Project')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 6)
    cy.get('#q_facility_project_project_id').select('Any')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 6)
    cy.get('#logout').click()
  })

  it('Search Task contains Facility', function() {
    cy.get('#q_facility_project_facility_facility_name').type('Test Facility 1').should('have.value', 'Test Facility 1')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 2)

    cy.get('#q_facility_project_facility_facility_name').clear().type('Test Facility 2').should('have.value', 'Test Facility 2')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 2)

    cy.get('#q_facility_project_facility_facility_name').clear().type('Test Facility 3').should('have.value', 'Test Facility 3')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 1)

    cy.get('#q_facility_project_facility_facility_name').clear().type('Test Facility 4').should('have.value', 'Test Facility 4')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 1)

    cy.get('#logout').click()
  })

  it('Search Task contains Progress', function() {
    cy.get('#q_progress').type('10').should('have.value', '10')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').scrollIntoView()
    cy.get('.current_filter').contains('Progress equals 10').should('be.visible')
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 1)

    cy.get('#q_progress').clear().type('100').should('have.value', '100')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').scrollIntoView()
    cy.get('.current_filter').contains('Progress equals 100').should('be.visible')
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 1)

    cy.get('#q_progress').clear().type('40').should('have.value', '40')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').scrollIntoView()
    cy.get('.current_filter').contains('Progress equals 40').should('be.visible')
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 2)

    cy.get('#q_progress').clear().type('70').should('have.value', '70')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').scrollIntoView()
    cy.get('.current_filter').contains('Progress equals 70').should('be.visible')
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 2)

    cy.get('#logout').click()
  })
})
