describe('Admin Panel Project', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openProjectAP()
  })

  it('Click on Projects on tabs open Project information page', function() {
    cy.get('#page_title').contains('Projects').should('be.visible')
    cy.get('#index_table_projects').should('be.visible')
    cy.get('#index_table_projects > tbody > tr').its('length').should('be.eq', 1)
    cy.get('#logout').click()
  })

  it('Open and close new Project form', function() {
    cy.get('.action_item > a').contains('New Project').click()
    cy.get('#page_title').contains('New Project').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })

  it('Create new project', function() {
    cy.get('.action_item > a').contains('New Project').click()
    cy.get('#page_title').contains('New Project').should('be.visible')
    cy.get('#project_name').type('New Test Project')
    cy.get('#project_submit_action').contains('Create Project').click()
    cy.get('#index_table_projects > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })
})
