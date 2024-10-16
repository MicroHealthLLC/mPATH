describe('Sheets Notes View', function() {
  before(() => {
    cy.cleanData()
    cy.appScenario('basic')
    cy.appScenario('contract/basic')
  })

  beforeEach(() => {
    cy.login('client@test.com', 'T3$tClient')
    cy.openContractSheet()
    // cy.get('#customtabs > :nth-child(6)').contains('Notes').should('be.visible').click()
    cy.get('[data-cy=notes]').contains('Notes').should('be.visible').click()

  })
  
  after(() => {
    // cy.clearCookies()
  })

  it('Open Sheets notes in a facility', function() {
    cy.get('[data-cy=search_notes]').should('be.visible')
    cy.get('[data-cy=notes]').should('be.visible')
    // cy.logout()
  })

  it('Search note by typing title', function() {
    // cy.get('[data-cy=notes]').its('length').should('be.eq', 1)
    cy.get('[data-cy=notes_show]').its('length').should('be.eq', 1)
    cy.get('[data-cy=search_notes]').clear().type('Note is not in the list').should('have.value', 'Note is not in the list')
    cy.contains('No notes found..').should('be.visible')

    cy.get('[data-cy=search_notes]').clear().type('Test Note').should('have.value', 'Test Note')

    cy.get('[data-cy=notes_show]').its('length').should('be.eq', 1)
    cy.get('[data-cy=search_notes]').clear()

    cy.get('[data-cy=notes_show]').its('length').should('be.eq', 1)
    // cy.logout()
  })
})
