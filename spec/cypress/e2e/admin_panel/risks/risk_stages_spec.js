describe('Admin Panel Risk Stages', function() {
  before(() => {
    // cy.clearCookies()
    cy.cleanData()
    cy.appScenario('basic')

  })
  beforeEach(() => {
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openRiskStageAP()
    cy.get('#tabs').within(() => {
      cy.get('#risk_stages').contains('Risk Stages').click({force: true})
    })
  })

  it('Click on Risk Stages on tabs open Risk Stage information page', function() {
    cy.get('#page_title').contains('Risk Stages').should('be.visible')
    cy.get('#index_table_risk_stages').should('be.visible')
    cy.get('#index_table_risk_stages > tbody > tr').its('length').should('be.eq', 2)
  })

  it('Open and close new Risk Stage form', function() {
    cy.get('.action_item > a').contains('New Risk Stage').click()
    cy.get('#page_title').contains('New Risk Stage').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
  })

  // it('Sort Risk Stage according to Name', function() {
  //   cy.get('.sortable').contains('Name').click()
  //   cy.get('#index_table_risk_stages > tbody > tr').first().contains('Test Risk Stage').should('be.visible')
  //   cy.get('.sortable').contains('Name').click()
  //   cy.get('#index_table_risk_stages > tbody > tr').first().contains('1 New Test Risk Stage').should('be.visible')
  //   cy.get('.sortable').contains('Name').click()
  //   cy.get('#index_table_risk_stages > tbody > tr').first().contains('Test Risk Stage').should('be.visible')
  // })

  it('Sort Risk Stage according to Percentage', function() {
    cy.get('.sortable').contains('Percentage').click()
    cy.get('#index_table_risk_stages > tbody > tr').first().contains(40).should('be.visible')
    // cy.get('.sortable').contains('Percentage').click()
    // cy.get('#index_table_risk_stages > tbody > tr').first().contains(0).should('be.visible')
    cy.get('.sortable').contains('Percentage').click()
    cy.get('#index_table_risk_stages > tbody > tr').first().contains(60).should('be.visible')
  })

  it('Could not Delete Risk Stage of foreign constraint', function() {
    cy.get('#index_table_risk_stages').should('be.visible')
    cy.get('#index_table_risk_stages > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Not able to delete this! Violates foreign key constraint.').should('be.visible')
    cy.get('#index_table_risk_stages > tbody > tr').its('length').should('be.eq', 2)
  })

  it('Delete Risk Stage', function() {
    cy.get('.action_item > a').contains('New Risk Stage').click()
    cy.get('#risk_stage_name').type('1 New Test Risk Stage').should('have.value', '1 New Test Risk Stage')
    cy.get('#risk_stage_submit_action').contains('Create Risk stage').click()
    cy.get('#index_table_risk_stages > tbody > tr').last().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.contains('Risk stage was successfully destroyed.').should('be.visible')
    cy.get('#index_table_risk_stages > tbody > tr').its('length').should('be.eq', 2)
  })

  it('Create new Risk Stage', function() {
    cy.get('.action_item > a').contains('New Risk Stage').click()
    cy.get('#page_title').contains('New Risk Stage').should('be.visible')
    cy.get('#risk_stage_name').type('1 New Test Risk Stage').should('have.value', '1 New Test Risk Stage')
    cy.get('#risk_stage_submit_action').contains('Create Risk stage').click()
    cy.get('.flashes').contains('Risk stage was successfully created.')
    cy.get('#index_table_risk_stages > tbody > tr').its('length').should('be.eq', 3)
  })

  it('Could not create new risk stage if name is blank', function() {
    cy.get('.action_item > a').contains('New Risk Stage').click()
    cy.get('#page_title').contains('New Risk Stage').should('be.visible')
    cy.get('#risk_stage_submit_action').contains('Create Risk stage').click()
    cy.get('.inline-errors').contains("can't be blank")
    cy.get('#page_title').contains('New Risk Stage').should('be.visible')
  })

  it('Search Risk Stage contains name', function() {
    cy.get('#q_name').type('1 New Test Risk Stage').should('have.value', '1 New Test Risk Stage')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Name contains 1 New Test Risk Stage').should('be.visible')
    cy.get('#index_table_risk_stages > tbody > tr').its('length').should('be.eq', 1)
    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
  })
})
