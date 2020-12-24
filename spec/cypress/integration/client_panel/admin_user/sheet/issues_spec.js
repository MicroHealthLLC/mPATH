describe('Sheets Issues View', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openFacilitySheet()
    cy.get('[data-cy=facility_tabs]').contains('Issues').should('be.visible').click()
  })

  it('Open Sheets issues in a facility', function() {
    cy.get('[data-cy=issue_sheet_index]').within(() => {
      cy.get('[data-cy=issue_total]').contains('Total: 2').should('be.visible')
      cy.get('[data-cy=issues_table]').should('be.visible')
    })
    cy.logout()
  })

  it('Open and Close Issue form sheet view', function() {
    cy.get('[data-cy=issue_sheet_index]').within(() => {
      cy.get('[data-cy=add_issue]').should('be.exist').click({force: true})
    })
    cy.get('[data-cy=issue_save_btn]').should('be.disabled')
    cy.get('[data-cy=issue_close_btn]').should('be.exist').click({force: true})
    cy.logout()
  })

  it('Open issue from sheet issue table', function() {
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').first().should('be.exist').click({force: true})
    })
    cy.get('[data-cy=issue_close_btn]').should('be.exist').click({force: true})
    cy.logout()
  })

  it('Update issue from sheet issue table', function() {
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').first().should('be.exist').click({force: true})
    })
    cy.get('[data-cy=issue_title]').clear({force: true}).type('Updated new test issue', {force: true}).should('have.value', 'Updated new test issue')
    cy.get('[data-cy=issue_save_btn]').click({force: true})
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').contains('Updated new test issue').should('be.exist')
    })
    cy.logout()
  })

  it('Delete issue from sheet issue table', function() {
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').its('length').should('be.eq', 2)
      cy.get('[data-cy=issue_row]').first().should('be.exist').click({force: true})
    })

    cy.get('[data-cy=issue_delete_btn]').should('be.exist').click({force: true})
    cy.wait(1000)
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').its('length').should('be.eq', 1)
      cy.get('[data-cy=issue_row]').first().should('be.exist').click({force: true})
    })

    cy.get('[data-cy=issue_delete_btn]').should('be.exist').click({force: true})
    cy.wait(1000)
    cy.get('[data-cy=issues_table]').should('not.exist')
    cy.get('[data-cy=no_issue_found]').contains('No issues found..')
    cy.logout()
  })

  it('Search issue by typing title', function() {
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').its('length').should('be.eq', 2)
    })
    cy.get('[data-cy=search_issues]').clear().type('Issue is not in the list').should('have.value', 'Issue is not in the list')
    cy.contains('No issues found..').should('be.visible')

    cy.get('[data-cy=search_issues]').clear().type('Test Issue').should('have.value', 'Test Issue')
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').its('length').should('be.eq', 1)
    })
    cy.get('[data-cy=search_issues]').clear()
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').its('length').should('be.eq', 2)
    })
    cy.logout()
  })

  it('Select issue status from list to display related issues', function() {
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').its('length').should('be.eq', 2)
    })
    cy.get('[data-cy=issue_status_list]').as('list')
    cy.get('@list').click()
    cy.get('@list').within(() => {
      cy.contains('complete').click()
    })
    cy.contains('No issues found..').should('be.visible')
    cy.get('@list').within(() => {
      cy.contains('all').click()
    })
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').its('length').should('be.eq', 2)
    })
    cy.logout()
  })
})
