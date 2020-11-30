describe('Notes Page', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.notesList()
  })

  it('Open Notes list page of a Facility', function() {
    cy.contains('My Notes')
    cy.get('[data-cy=note_total]').contains('Total: 0')
    cy.contains('No notes found..')
    cy.logout()
  })

  it('Open new Note form', function() {
    cy.get('[data-cy=new_note]').click()
    cy.get('[data-cy=note_save_btn]').should('be.disabled')
    cy.logout()
  })

  it('Create new note in a Facility', function() {
    cy.createNewNote()
    cy.get('[data-cy=note_total]').contains('Total: 1')
    cy.get('[data-cy=note_list]').contains('New test note')
    cy.logout()
  })

  it('Delete the note, after open the note from the form delete button', function() {
    cy.createNewNote()
    cy.get('[data-cy=note_total]').contains('Total: 1')
    cy.get('[data-cy=note_list]').contains('New test note')
    cy.get('[data-cy=note_edit_icon]').click()
    cy.get('[data-cy=note_delete_btn]').click()
    cy.get('[data-cy=note_total]').contains('Total: 0')
    cy.logout()
  })

  it('Delete the note, without open it using delete icon', function() {
    cy.createNewNote()
    cy.get('[data-cy=note_total]').contains('Total: 1')
    cy.get('[data-cy=note_list]').contains('New test note')
    cy.get('[data-cy=note_delete_icon]').click()
    cy.get('[data-cy=note_total]').contains('Total: 0')
    cy.contains('No notes found..')
    cy.logout()
  })

  it('Update note description', function() {
    cy.createNewNote()
    cy.get('[data-cy=note_list]').contains('New test note')
    cy.get('[data-cy=note_edit_icon]').click()
    cy.get('[data-cy=note_details]').clear().type('Updated new test note').should('have.value', 'Updated new test note')
    cy.get('[data-cy=note_save_btn]').click()
    cy.get('[data-cy=note_list]').contains('Updated new test note')
    cy.get('[data-cy=note_total]').contains('Total: 1')
    cy.logout()
  })

  it("In note's form if details not given save button must be disabled", function() {
    cy.createNewNote()
    cy.get('[data-cy=note_list]').contains('New test note')
    cy.get('[data-cy=note_edit_icon]').click()
    cy.get('[data-cy=note_details]').clear()
    cy.get('[data-cy=note_save_btn]').should('be.disabled')
    cy.get('[data-cy=note_close_btn]').click()
    cy.get('[data-cy=note_total]').contains('Total: 1')
    cy.logout()
  })
})
