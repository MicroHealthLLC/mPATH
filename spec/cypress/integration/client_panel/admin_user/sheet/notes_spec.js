describe('Sheets Notes View', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openFacilitySheet()
    cy.get('[data-cy=facility_tabs]').contains('Notes').should('be.visible').click()
  })

  it('Open Notes list page', function() {
    cy.get('[data-cy=note_list]').contains('My Note').should('be.visible')
    cy.logout()
  })

  it('Open new Note form', function() {
    cy.get('[data-cy=new_note]').click()
    cy.get('[data-cy=note_save_btn]').should('be.disabled')
    cy.get('[data-cy=note_close_btn]').click({force: true})
    cy.logout()
  })

  it('Delete the note, after open the note from the form delete button', function() {
    cy.get('[data-cy=notes]').its('length').should('be.eq', 1)
    cy.get('[data-cy=notes]').first().within(() => {
      cy.get('[data-cy=note_edit_icon]').click()
    })
    cy.get('[data-cy=note_delete_btn]').click({force: true})
    cy.get('[data-cy=notes]').should('not.exist')
    cy.get('[data-cy=note_list]').contains('No notes found..').should('be.visible')
    cy.logout()
  })

  it('Delete the note, without open it using delete icon', function() {
    cy.get('[data-cy=notes]').its('length').should('be.eq', 1)
    cy.get('[data-cy=notes]').first().within(() => {
      cy.get('[data-cy=note_delete_icon]').click()
    })
    cy.get('[data-cy=notes]').should('not.exist')
    cy.get('[data-cy=note_list]').contains('No notes found..').should('be.visible')
    cy.logout()
  })

  it('Update note description', function() {
    cy.get('[data-cy=notes]').first().within(() => {
      cy.get('[data-cy=note_edit_icon]').click()
    })
    cy.get('[data-cy=note_details]').clear({force: true})
      .type('Updated new test note', {force: true}).should('have.value', 'Updated new test note')
    cy.get('[data-cy=note_save_btn]').click({force: true})
    cy.get('[data-cy=note_list]').contains('Updated new test note').should('be.visible')
    cy.logout()
  })

  it("In note's form if details not given save button must be disabled", function() {
    cy.get('[data-cy=notes]').first().within(() => {
      cy.get('[data-cy=note_edit_icon]').click()
    })
    cy.get('[data-cy=note_details]').clear({force: true})
    cy.get('[data-cy=note_save_btn]').should('be.disabled')
    cy.get('[data-cy=note_close_btn]').click({force: true})
    cy.logout()
  })

  it('Search the note by typing title', function() {
    cy.get('[data-cy=search_notes]').clear().type('Note is not in the list').should('have.value', 'Note is not in the list')
    cy.get('[data-cy=note_list]').contains('No notes found..').should('be.visible')

    cy.get('[data-cy=search_notes]').clear().type('Test Note').should('have.value', 'Test Note')
    cy.get('[data-cy=note_list]').contains('Test Note').should('be.visible')
    cy.get('[data-cy=notes]').its('length').should('be.eq', 1)

    cy.get('[data-cy=search_notes]').clear()
    cy.get('[data-cy=note_list]').contains('Test Note').should('be.visible')
    cy.get('[data-cy=notes]').its('length').should('be.eq', 1)
    cy.logout()
  })
})
