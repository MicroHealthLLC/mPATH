describe('Admin Panel Task Categories', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openTaskCategoryAP()
  })

  it('Click on Task Categories on tabs open Task Category information page', function() {
    cy.get('#page_title').contains('Task Categories').should('be.visible')
    cy.get('#index_table_task_types').should('be.visible')
    cy.get('#index_table_task_types > tbody > tr').its('length').should('be.eq', 1)
    cy.get('#logout').click()
  })

  it('Open and close new Task Category form', function() {
    cy.get('.action_item > a').contains('New Task Category').click()
    cy.get('#page_title').contains('New Task Category').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })

  it('Create new Task Category', function() {
    cy.get('.action_item > a').contains('New Task Category').click()
    cy.get('#page_title').contains('New Task Category').should('be.visible')
    cy.get('#task_type_name').type('New Test Task Type')
    cy.get('#task_type_submit_action').contains('Create Task Category').click()
    cy.get('#index_table_task_types > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })
})
