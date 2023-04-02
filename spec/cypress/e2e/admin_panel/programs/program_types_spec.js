describe('Admin Panel Program Types', function() {
  before(() => {
    cy.cleanData()
    cy.appScenario('basic')

  })

  beforeEach(() => {
    cy.get('#tabs').within(() => {
      cy.get('#project_types').contains('Program Types').click({force: true})
    })
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openProgramTypeAP()
  })

  it('Click on Program Types on tabs open Program Type information page', function() {
    cy.get('#page_title').contains('Program Types').should('be.visible')
    cy.get('#index_table_project_types').should('be.visible')
    cy.get('#index_table_project_types > tbody > tr').its('length').should('be.eq', 1)
    // cy.get('#logout').click()
  })

  it('Open and close new Program Type form', function() {
    cy.get('.action_item > a').contains('New Program Type').click()
    cy.get('#page_title').contains('New Program Type').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    // cy.get('#logout').click()
  })

  it('Could not Delete Program type of foreign constraint', function() {
    cy.get('#index_table_project_types').should('be.visible')
    cy.get('#index_table_project_types > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Not able to delete this! Violates foreign key constraint.').should('be.visible')
    cy.get('#index_table_project_types > tbody > tr').its('length').should('be.eq', 1)
    // cy.get('#logout').click()
  })

  it('Delete Program Type', function() {
    cy.get('.action_item > a').contains('New Program Type').click()
    cy.get('#project_type_name').type('New Test Project Type').should('have.value', 'New Test Project Type')
    cy.get('#project_type_submit_action').contains('Create Program Type').click()
    cy.get('#index_table_project_types > tbody > tr').last().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Program Type was successfully destroyed.').should('be.visible')
    cy.get('#index_table_project_types > tbody > tr').its('length').should('be.eq', 1)
    // cy.get('#logout').click()
  })

  it('Create new program Type', function() {
    cy.get('.action_item > a').contains('New Program Type').click()
    cy.get('#page_title').contains('New Program Type').should('be.visible')
    cy.get('#project_type_name').type('New Test Project Type').should('have.value', 'New Test Project Type')
    cy.get('#project_type_submit_action').contains('Create Program Type').click()
    cy.get('.flashes').contains('Program Type was successfully created.')
    cy.get('#index_table_project_types > tbody > tr').its('length').should('be.eq', 2)
    // cy.get('#logout').click()
  })

  it('Could not create new Program Type if name is blank', function() {
    cy.get('.action_item > a').contains('New Program Type').click()
    cy.get('#page_title').contains('New Program Type').should('be.visible')
    cy.get('#project_type_submit_action').contains('Create Program Type').click()
    cy.get('.errors').contains("Name can't be blank")
    cy.get('.inline-errors').contains("can't be blank")
    cy.get('#page_title').contains('New Program Type').should('be.visible')
    // cy.get('#logout').click()
  })

  it('Sort Project type according to Name', function() {
    cy.visit("http://localhost:5017/admin/project_types?order=name_asc")
    cy.get('.sortable').contains('Name').click()
    cy.get('#index_table_project_types > tbody > tr').first().contains('Test Project Type').should('be.visible')
    // cy.get('#logout').click()
  })

  it('Search Program type contains name', function() {
    cy.get('#q_name').type('New Test Project Type').should('have.value', 'New Test Project Type')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Name contains New Test Project Type').should('be.visible')
    cy.get('#index_table_project_types > tbody > tr').its('length').should('be.eq', 1)
    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
    // cy.get('#logout').click()
  })
})
