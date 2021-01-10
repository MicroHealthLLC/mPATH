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
})
