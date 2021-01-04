describe('Admin Panel Risk Stages', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openRiskStageAP()
  })

  it('Click on Risk Stages on tabs open Risk Stage information page', function() {
    cy.get('#page_title').contains('Risk Stages').should('be.visible')
    // cy.get('#index_table_risk_stages').should('be.visible')
    cy.get('#index_table_risk_stages').should('not.exist')
    cy.get('#logout').click()
  })

  it('Open and close new Risk Stage form', function() {
    cy.get('.action_item > a').contains('New Risk Stage').click()
    cy.get('#page_title').contains('New Risk Stage').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })

  it('Create new Risk Stage', function() {
    cy.get('.action_item > a').contains('New Risk Stage').click()
    cy.get('#page_title').contains('New Risk Stage').should('be.visible')
    cy.get('#risk_stage_name').type('New Test Risk Stage')
    cy.get('#risk_stage_submit_action').contains('Create Risk stage').click()
    cy.get('#index_table_risk_stages > tbody > tr').its('length').should('be.eq', 1)
    cy.get('#logout').click()
  })
})
