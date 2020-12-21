describe('Notes Page', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('client@test.com', 'T3$tClient')
    cy.notesList()
  })

  it('Open Notes list page of a Facility', function() {
    cy.get('[data-cy=note_list]').contains('My Note').should('be.visible')
    cy.logout()
  })

  it('Cannot open new Note form or edit/delete existing note', function() {
    cy.get('[data-cy=note_list]').within(() => {
      cy.get('[data-cy=new_note]').should('not.exist')
      cy.get('[data-cy=note_delete_icon]').should('not.exist')
      cy.get('[data-cy=note_edit_icon]').should('not.exist')
    })
    cy.logout()
  })

  it('Search the note by typing title', function() {
    cy.get('[data-cy=search_notes]').clear().type('Note is not in the list').should('have.value', 'Note is not in the list')
    cy.get('[data-cy=note_list]').contains('No notes found..').should('be.visible')
    cy.get('[data-cy=search_notes]').clear()
    cy.get('[data-cy=notes]').its('length').should('be.eq', 1)
    cy.logout()
  })
})

describe('Client do not have permission to view notes', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.appScenario('remove_note_permission')
    cy.login('client@test.com', 'T3$tClient')
    cy.notesList()
  })

  it('Notes permission access display', function() {
    cy.get('[data-cy=note_list]').contains("You don't have permissions to read!").should('be.visible')
    cy.logout()
  })
})
